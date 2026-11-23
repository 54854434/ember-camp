"""Build a timestamp-labelled contact sheet for a local video."""

import argparse
from io import BytesIO
import json
from math import isfinite
from pathlib import Path
import subprocess
import sys

from PIL import Image, ImageDraw


def run(command):
    return subprocess.run(
        command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, check=True, timeout=60
    ).stdout


def probe(video, ffprobe):
    metadata = json.loads(run([
        ffprobe, "-v", "error", "-show_entries", "format=duration:stream=codec_type",
        "-of", "json", "-i", str(video),
    ]))
    track_types = [stream["codec_type"] for stream in metadata.get("streams", [])]
    duration = float(metadata.get("format", {}).get("duration", "nan"))
    if "video" not in track_types or not isfinite(duration) or duration <= 0:
        raise ValueError("A readable video with a finite duration is required.")
    return duration, "audio" in track_types


def extract(video, timestamp, ffmpeg):
    contents = run([
        ffmpeg, "-nostdin", "-v", "error", "-ss", f"{timestamp:.6f}", "-i", str(video),
        "-map", "0:v:0", "-frames:v", "1",
        "-vf", "scale=280:280:force_original_aspect_ratio=decrease,setsar=1",
        "-c:v", "png", "-threads", "1", "-f", "image2pipe", "pipe:1",
    ])
    if not contents:
        raise ValueError(f"No frame decoded near {timestamp:.3f} seconds.")
    with Image.open(BytesIO(contents)) as frame:
        return frame.convert("RGB")


def render_sheet(frames, timestamps):
    columns = min(len(frames), 5)
    rows = (len(frames) + columns - 1) // columns
    tile_width = max(frame.width for frame in frames) + 16
    frame_height = max(frame.height for frame in frames)
    tile_height = frame_height + 32
    sheet = Image.new("RGB", (columns * tile_width, rows * tile_height), "#161b22")
    draw = ImageDraw.Draw(sheet)
    for index, (frame, timestamp) in enumerate(zip(frames, timestamps)):
        x = (index % columns) * tile_width
        y = (index // columns) * tile_height
        sheet.paste(frame, (x + (tile_width - frame.width) // 2, y + 8))
        draw.text((x + 8, y + frame_height + 12), f"{timestamp:05.2f} s", fill="white")
    return sheet


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("video", type=Path)
    parser.add_argument("--out", required=True, type=Path)
    parser.add_argument("--times", nargs="+", type=float)
    parser.add_argument("--ffmpeg", default="ffmpeg")
    parser.add_argument("--ffprobe", default="ffprobe")
    args = parser.parse_args()
    if not args.video.is_file():
        parser.error("video must be an existing local file")
    if args.out.suffix.lower() != ".png" or args.out.exists():
        parser.error("--out must be a new .png file")

    duration, has_audio = probe(args.video, args.ffprobe)
    timestamps = args.times or [duration * fraction for fraction in (0, 0.25, 0.5, 0.75, 0.96)]
    if any(not isfinite(time) or not 0 <= time < duration for time in timestamps):
        parser.error(f"sample times must be between 0 and {duration:.3f} seconds (exclusive end)")

    frames = [extract(args.video, timestamp, args.ffmpeg) for timestamp in timestamps]
    sheet = render_sheet(frames, timestamps)
    with args.out.open("xb") as output:
        sheet.save(output, format="PNG")
    print(json.dumps({
        "source": str(args.video.resolve()),
        "duration": duration,
        "audio_track": has_audio,
        "requested_times": timestamps,
        "contact_sheet": str(args.out.resolve()),
    }, ensure_ascii=False))


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as error:
        print(error.stderr.decode(errors="replace").strip(), file=sys.stderr)
        sys.exit(1)
    except (OSError, ValueError, subprocess.TimeoutExpired) as error:
        print(error, file=sys.stderr)
        sys.exit(1)
