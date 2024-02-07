# coding: utf-8
"""
Utility you can run to check links in wiki pages.
Prints out internal links that either don't follow `/_wiki/***.md` format, or don't exist.
"""

from pathlib import Path
from re import findall

for file in Path("./_wiki/").glob("*.md"):
    text = file.read_text()
    # regex finds markdown links `[...](...)` and captures the part in `(...)`
    links = findall(r"\[[^\]]*\]\(([^\)]*)\)", text)
    for link in links:
        if link.startswith("http"):
            # skip external links
            continue
        
        if not link.startswith("/_wiki/") or not link.endswith(".md"):
            print(f"Link unrecognised format in {file}: {link}")
            continue
        
        link_path = Path(".") / link.removeprefix("/")
        if not link_path.exists():
            print(f"Link destination not found in {file}: {link}")
