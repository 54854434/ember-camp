"""Check how much of a DirectorDesk clip the local H3 1160 path can use."""

import argparse
import json
import math
from pathlib import Path
import shutil
import subprocess

FPS = 24
MAX_VIDEO_FRAMES = 240
FRAME_STEP = 17
MIN_FRAMES = 5


def aligned_up(frames):
    return frames + (MIN_FRAMES - frames) % FRAME_STEP


def audit(ffmpeg, video, h3_seconds):
    command = [
        str(ffmpeg), "-hide_banner", "-loglevel", "error", "-nostdin", "-xerror",
        "-progress", "pipe:1", "-nostats", "-i", str(video), "-map", "0:v:0",
        "-an", "-sn", "-dn", "-vf", f"fps={FPS}", "-frames:v", str(MAX_VIDEO_FRAMES + 1),
        "-f", "null", "-",
    ]
    run = subprocess.run(
        command, capture_output=True, encoding="utf-8", errors="replace", timeout=60,
        creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
    )
    if run.returncode:
        raise ValueError(run.stderr.strip() or "FFmpeg could not decode the reference")
    progress = dict(line.strip().split("=", 1) for line in run.stdout.splitlines() if "=" in line)
    if progress.get("progress") != "end" or "frame" not in progress:
        raise ValueError("FFmpeg did not report a complete video frame count")
    decoded = int(progress["frame"])
    manager_frames = min(decoded, MAX_VIDEO_FRAMES)
    generation_frames = (
        aligned_up(max(MIN_FRAMES, round(h3_seconds * FPS))) if h3_seconds is not None else None
    )
    available = manager_frames if generation_frames is None else min(manager_frames, generation_frames)
    retained = available - (available - MIN_FRAMES) % FRAME_STEP if available >= MIN_FRAMES else 0
    return {
        "reference_video": str(video),
        "reference_fps": FPS,
        "decode_probe_frames": decoded,
        "exceeds_manager_cap": decoded > MAX_VIDEO_FRAMES,
        "manager_loaded_frames": manager_frames,
        "h3_generation_aligned_frames": generation_frames,
        "h3_reference_frames": retained,
        "h3_reference_seconds": round(retained / FPS, 4),
        "last_reference_frame_seconds": round((retained - 1) / FPS, 4) if retained else None,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("video", type=Path)
    parser.add_argument("--h3-seconds", type=float, help="Duration configured for H3 first pass")
    parser.add_argument("--ffmpeg", type=Path, help="Override the local FFmpeg executable")
    args = parser.parse_args()
    video = args.video.resolve()
    if not video.is_file():
        parser.error(f"video does not exist: {video}")
    if args.h3_seconds is not None and (not math.isfinite(args.h3_seconds) or args.h3_seconds <= 0):
        parser.error("--h3-seconds must be a finite, positive duration")
    local_ffmpeg = Path("维护工具/ffmpeg/ffmpeg.exe")
    ffmpeg = args.ffmpeg or (local_ffmpeg.resolve() if local_ffmpeg.is_file() else shutil.which("ffmpeg"))
    if not ffmpeg:
        parser.error("FFmpeg was not found; run from the ComfyUI workspace or pass --ffmpeg")
    ffmpeg = Path(ffmpeg).resolve()
    try:
        result = audit(ffmpeg, video, args.h3_seconds)
    except (OSError, ValueError, subprocess.TimeoutExpired) as error:
        parser.exit(1, f"Reference check failed: {error}\n")
    print(json.dumps(result, ensure_ascii=True, indent=2))
    return 0 if result["h3_reference_frames"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
