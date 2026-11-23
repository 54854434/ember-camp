"""Check a MiniMax H3 model body or a complete 1160 prompt for T2VA or Ref2VA."""

import argparse
import json
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
SEGMENT_PATTERN = re.compile(r"(?ms)^\[SHOT_START\][ \t]*\n(.*?)^\[SHOT_END\][ \t]*$")
SECTION_PATTERN = re.compile(r"(?m)^===([A-Z0-9_]+)===[ \t]*$")
SECTIONS_1160 = ("H3_PROMPT", "SCENE_INSTRUCTION", "VIDEO_INSTRUCTION", "AUDIO_INSTRUCTION")
SEGMENT_DURATION_PATTERN = re.compile(r"(?m)^\*\*时长\*\*:[ \t]*(\d+(?:\.\d+)?)[ \t]*秒[ \t]*$")


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


def check_1160_slots(section, raw_slots, mode):
    try:
        instruction = json.loads(raw_slots)
    except json.JSONDecodeError as error:
        raise ValueError(f"{section} must contain valid JSON: {error.msg}.") from error
    slots = instruction.get("slots") if isinstance(instruction, dict) else None
    if not isinstance(slots, list) or any(not isinstance(slot, str) for slot in slots):
        raise ValueError(f"{section} needs a slots array containing strings.")
    if mode == "t2va" and slots:
        raise ValueError(f"{section} must have empty slots for a text-only segment.")


def parse_1160_bodies(prompt, mode, duration):
    bodies = []
    previous_end = 0
    for index, block in enumerate(SEGMENT_PATTERN.finditer(prompt), start=1):
        content = block.group(1)
        if prompt[previous_end:block.start()].strip() or "[SHOT_START]" in content:
            raise ValueError(f"Unmatched segment markers around segment {index}.")
        parts = SECTION_PATTERN.split(content)
        if tuple(parts[1::2]) != SECTIONS_1160:
            raise ValueError(f"Segment {index} needs sections in order: {', '.join(SECTIONS_1160)}.")
        metadata, body, scene, video, audio = parts[::2]
        declared = SEGMENT_DURATION_PATTERN.search(metadata)
        if declared and duration is not None and float(declared.group(1)) != duration:
            raise ValueError(f"Segment {index} lists {declared.group(1)}s, panel duration is {duration:g}s.")
        for section, raw_slots in zip(SECTIONS_1160[1:], (scene, video, audio)):
            check_1160_slots(section, raw_slots, mode)
        bodies.append(body.strip())
        previous_end = block.end()
    if not bodies or prompt[previous_end:].strip():
        raise ValueError("Match each [SHOT_START] with [SHOT_END].")
    return bodies


def check_body(prompt, mode, duration):
    fields = parse_fields(prompt, mode)
    if mode == "t2va" and re.search(r"<(?:Picture|Video|Audio) \d+>", prompt):
        raise ValueError("T2VA uses a text-only body. Choose a reference mode for asset tags.")
    return check_shots(fields[DESCRIPTION_FIELDS[mode]], mode, duration)


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
        wrapped = prompt.startswith("[SHOT_START]")
        bodies = parse_1160_bodies(prompt, args.mode, args.duration) if wrapped else [prompt]
        shot_count = sum(check_body(body, args.mode, args.duration) for body in bodies)
    except (OSError, ValueError) as error:
        parser.error(str(error))
    print(
        f"H3 {args.mode}: {len(bodies)} segment(s), {len(MODE_FIELDS[args.mode])} fields per segment, "
        f"{shot_count} shot(s)."
    )


if __name__ == "__main__":
    main()
