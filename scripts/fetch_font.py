"""Fetch the original Noto CJK SC font and OFL license from its official source."""
from pathlib import Path
from urllib.request import urlopen
import hashlib

ROOT = Path(__file__).resolve().parents[1]
# A source pin is recorded by the release packaging step in FONT_SOURCE.txt.
source = (ROOT / "assets/FONT_SOURCE.txt").read_text().strip()
base = f"https://raw.githubusercontent.com/notofonts/noto-cjk/{source}/Sans"
for remote, local in [("OTF/SimplifiedChinese/NotoSansCJKsc-Regular.otf", "NotoSansCJKsc-Regular.otf"), ("LICENSE", "OFL.txt")]:
    target = ROOT / "assets" / local
    if target.exists():
        continue
    with urlopen(f"{base}/{remote}", timeout=120) as response:
        target.write_bytes(response.read())
    print(local, hashlib.sha256(target.read_bytes()).hexdigest())
