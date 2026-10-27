# Split the converted memoir and notes (sketch.md, notes.md from ws2md.py) into the sample book's section files.
import re, sys
from pathlib import Path
out = Path(sys.argv[1]); (out / "text").mkdir(parents=True, exist_ok=True)

def split_defs(md):
    body, defs = [], {}
    cur = None
    for line in md.split("\n"):
        m = re.match(r"\[\^([\w-]+)\]: (.*)", line)
        if m:
            cur = m.group(1); defs[cur] = [m.group(2)]; continue
        if cur and (line.startswith("    ") or line == ""):
            defs[cur].append(line); continue
        cur = None; body.append(line)
    return "\n".join(body), {k: "\n".join(v).rstrip() for k, v in defs.items()}

def with_defs(text, defs):
    used = re.findall(r"\[\^([\w-]+)\](?!:)", text)
    return text.rstrip() + "\n\n" + "\n\n".join(f"[^{k}]: {defs[k]}" for k in dict.fromkeys(used)) + "\n"

sk, skdefs = split_defs(Path("sketch.md").read_text())
sk = sk[sk.index("[p. 666]"):]
sk = sk[:sk.index("This work is a translation")]
sk = re.sub(r"\*\*ARTICLE XXIX\.\*\*\n\n\*\*\*Sketch.*?\*\*\*\n\n", "", sk, flags=re.S)
head = '# Sketch of the Analytical Engine Invented by Charles Babbage, Esq. {orig="Notions sur la machine analytique de M. Charles Babbage" run="Sketch of the Analytical Engine"}\n\n'
(out / "text/01-sketch.md").write_text(head + with_defs(sk, skdefs))

nt, ntdefs = split_defs(Path("notes.md").read_text())
nt = nt[nt.index("[p. 691]"):nt.index("This work was published before")]
nt = re.sub(r"\n\s*-{20,}\s*\n", "\n", nt)
nt = nt.replace("NOTES BY THE TRANSLATOR.", "")
parts = re.split(r"^NOTE ([A-G])\.—Page (\d+)\.\s*$", nt, flags=re.M)
lead = parts[0].strip()        # the [p. 691] marker
for i in range(1, len(parts), 3):
    letter, page, text = parts[i], parts[i + 1], parts[i + 2].strip()
    if letter == "A":
        text = lead + " " + text
    head = f'# Note {letter} {{orig="Notes by the Translator"}}\n\n::: right\n*To page {page}.*\n:::\n\n'
    (out / f"text/{i // 3 + 2:02d}-note-{letter.lower()}.md").write_text(head + with_defs(text, ntdefs))
for f in sorted((out / "text").glob("*.md")):
    t = f.read_text(); print(f.name, len(t.split()), "words", len(re.findall(r"\[\^[\w-]+\](?!:)", t)), "note refs", t.count("[p. "), "markers")
