# coding: utf-8
from pathlib import Path
from re import findall
for file in Path("./_wiki/").glob("*.md"):
    text = file.read_text()
    links = findall(r"\[[^\]]*\]\(([^\)]*)\)", text)
    for link in links:
        if link.startswith("http"):
            continue
        if not link.startswith("/_wiki/") or not link.endswith(".md"):
            print(f"Link unrecognised format in {file}: {link}")
            continue
        link_path = Path(".") / link.removeprefix("/")
        if not link_path.exists():
            print(f"Link destination not found in {file}: {link}")
