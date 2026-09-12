#!/usr/bin/env python
from __future__ import annotations
import argparse, html, re, sys
from pathlib import Path

MOJIBAKE_MAP = {
    "â€“": "–", "â€”": "—", "â€˜": "‘", "â€™": "’",
    "â€œ": "“", "â€": "”", "â€¦": "…", "â†’": "→",
    "â†": "←", "â‰¥": "≥", "â‰¤": "≤", "Â°": "°",
    "Â ": " ", "\u00a0": " ",
}
CONTROL_PATTERNS = [
    r"<\|[^>\n]{0,120}\|?>",
    r"\\?lt\|im_[^\s<]{0,120}",
    r"\\?gt\|im_[^\s<]{0,120}",
    r"<\|im_[^\s<]{0,120}",
]

def clean_text(text: str) -> str:
    for _ in range(2):
        text = html.unescape(text)
    for bad, good in MOJIBAKE_MAP.items():
        text = text.replace(bad, good)
    for pat in CONTROL_PATTERNS:
        text = re.sub(pat, "", text, flags=re.I)
    lines = [re.sub(r"[ \t]+$", "", line) for line in text.splitlines()]
    text = "\n".join(lines)
    text = re.sub(r"\n{4,}", "\n\n\n", text)
    text = re.sub(r"!\[([^\]]*)\]\(\s*\)", r"[\1]", text)
    return text.strip() + "\n"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("input")
    ap.add_argument("-o", "--output")
    ap.add_argument("--in-place", action="store_true")
    args = ap.parse_args()
    src = Path(args.input)
    if not src.exists():
        print(f"ERROR: not found: {src}", file=sys.stderr)
        return 2
    dst = src if args.in_place else (Path(args.output) if args.output else src.with_name(src.stem + ".clean.md"))
    cleaned = clean_text(src.read_text(encoding="utf-8", errors="replace"))
    dst.parent.mkdir(parents=True, exist_ok=True)
    dst.write_text(cleaned, encoding="utf-8", newline="\n")
    print(dst)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
