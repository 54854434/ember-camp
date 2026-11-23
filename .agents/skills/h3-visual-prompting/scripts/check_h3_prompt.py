"""Check the structure of a MiniMax H3 T2VA or Ref2VA model prompt."""

import argparse
import math
from pathlib import Path
import re


AUDIO_FIELDS = ("overall_soundscape", "non_diegetic_music")
DESCRIPTION_FIELDS = {
    "t2va": "integrated_multimodal_description",
    "ref2va": "detailed_description",
}
MODE_FIELDS = {
    "t2va": (DESCRIPTION_FIELDS["t2va"], *AUDIO_FIELDS),
    "ref2va": (
        "subject_definitions", "summary", "retention_analysis",
        DESCRIPTION_FIELDS["ref2va"], *AUDIO_FIELDS,
    ),
}
FIELD_PATTERN = re.compile(
    r"(?m)^(" + "|".join(dict.fromkeys(sum(MODE_FIELDS.values(), ()))) + r"):[ \t]*"
)
SHOT_PATTERN = re.compile(r"\[Shot (\d+)\]")
CUT_PATTERN = re.compile(r"At (\d{2}):([0-5]\d)\.(\d{3})\b")


def parse_fields(prompt, mode):
    headers = list(FIELD_PATTERN.finditer(prompt))
    if not headers or headers[0].start() != 0:
        raise ValueError("Start with the first model field. Pass the model body as plain text.")
    if tuple(header.group(1) for header in headers) != MODE_FIELDS[mode]:
        raise ValueError(f"Expected fields in this order: {', '.join(MODE_FIELDS[mode])}.")

    fields = {}
    for index, header in enumerate(headers):
        end = headers[index + 1].start() if index + 1 < len(headers) else len(prompt)
        contents = prompt[header.end():end]
        if not contents.strip():
            raise ValueError(f"Empty field: {header.group(1)}.")
        if mode == "t2va" and contents.startswith("\n"):
            raise ValueError(f"Start the value of {header.group(1)} on the field's own line.")
        fields[header.group(1)] = contents.strip()
    return fields


def check_shots(description, mode, duration):
    shots = list(SHOT_PATTERN.finditer(description))
    numbers = [int(shot.group(1)) for shot in shots]
    if not shots or numbers != list(range(1, len(shots) + 1)):
        raise ValueError("Use consecutive shot numbers starting at [Shot 1].")
    if mode == "t2va" and shots[0].start() != 0:
        raise ValueError("Place [Shot 1] immediately after integrated_multimodal_description:.")
    if CUT_PATTERN.match(description[shots[0].end():].lstrip()):
        raise ValueError("Shot 1 starts without an explicit cut time.")

    previous_time = 0.0
    for shot in shots[1:]:
        cut = CUT_PATTERN.match(description[shot.end():].lstrip())
        if not cut:
            raise ValueError(f"{shot.group(0)} must start with At MM:SS.mmm.")
        minutes, seconds, milliseconds = map(int, cut.groups())
        time = minutes * 60 + seconds + milliseconds / 1000
        if time <= previous_time or (duration is not None and time >= duration):
            raise ValueError("Cut times must increase and stay within the video duration.")
        previous_time = time
    return len(shots)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("prompt", type=Path)
    parser.add_argument("--mode", choices=MODE_FIELDS, required=True)
    parser.add_argument("--duration", type=float)
    args = parser.parse_args()
    if args.duration is not None and (not math.isfinite(args.duration) or args.duration <= 0):
        parser.error("--duration must be a positive number of seconds.")
    try:
        prompt = args.prompt.read_text(encoding="utf-8-sig").strip()
        fields = parse_fields(prompt, args.mode)
        if args.mode == "t2va" and re.search(r"<(?:Picture|Video|Audio) \d+>", prompt):
            raise ValueError("T2VA uses a text-only body. Choose a reference mode for asset tags.")
        shot_count = check_shots(fields[DESCRIPTION_FIELDS[args.mode]], args.mode, args.duration)
    except (OSError, ValueError) as error:
        parser.error(str(error))
    print(f"H3 {args.mode}: {len(fields)} fields, {shot_count} shot(s).")


if __name__ == "__main__":
    main()
