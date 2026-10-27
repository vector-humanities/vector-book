# Wikisource HTML (parse API) to Pandoc Markdown for the Vector Book sample edition.
# Page numbers become [p. N]; cite notes become Pandoc footnotes labelled PREFIX-N; tables go straight
# to raw Typst; links and Wikisource chrome go. How the text of examples/lovelace was first made:
#
#   curl the parse API (action=parse&prop=text&formatversion=2) for
#     Scientific_Memoirs/3/Sketch_of_the_Analytical_Engine_invented_by_Charles_Babbage,_Esq.  -> sketch.html
#     .../Notes_by_the_Translator                                                              -> notes.html
#   python3 -I ws2md.py sketch.html sketch.md m
#   python3 -I ws2md.py notes.html notes.md l
#   python3 -I assemble.py ../..          (writes text/; the files have been edited since)
import re, subprocess, sys
from pathlib import Path
FILTER = str(Path(__file__).with_name("clean.lua"))
src, out, prefix = sys.argv[1], sys.argv[2], sys.argv[3]
h = open(src, encoding="utf-8").read().replace("&#95;", "_")

def pandoc(html):
    return subprocess.run(["pandoc", "-f", "html", "-t",
        "markdown-raw_html-native_divs-native_spans-header_attributes-link_attributes-bracketed_spans-fenced_divs-smart",
        "--wrap=none", "--lua-filter", FILTER], input=html, capture_output=True, text=True).stdout.strip()

H0 = h
used_in_tables = set()
# footnote bodies
notes = {}
for m in re.finditer(r'<li id="cite_note-([\w-]+)">(.*?)</li>', h, flags=re.S):
    body = re.sub(r'<span class="mw-cite-backlink">.*?</span>', '', m.group(2), flags=re.S)
    notes[m.group(1)] = pandoc(body)
h = re.sub(r'<ol class="references">.*?</ol>', '', h, flags=re.S)
h = re.sub(r'<sup[^>]*class="reference"[^>]*>\s*<a href="#cite_note-([\w-]+)"[^>]*>.*?</a>\s*</sup>',
           lambda m: f'FNMARK{m.group(1)}FNEND', h, flags=re.S)
h = re.sub(r'<span[^>]*class="pagenum ws-pagenum"[^>]*data-page-number="(\d+)"[^>]*>.*?</span>(\s*</span>)?',
           lambda m: f'PGMARK{m.group(1)}PGEND', h, flags=re.S)
# top-level tables go straight to Typst (rowspans, colspans and notes in cells survive), not through Markdown
def typst(html):
    return subprocess.run(["pandoc", "-f", "html", "-t", "typst", "--wrap=none", "--lua-filter", FILTER],
                          input=html, capture_output=True, text=True).stdout.strip()

def note_typ(k):
    body = re.search(r'<li id="cite_note-' + re.escape(k) + r'">(.*?)</li>', H0, flags=re.S).group(1)
    body = re.sub(r'<span class="mw-cite-backlink">.*?</span>', '', body, flags=re.S)
    return typst(body)

tables, depth, start, pieces, last = [], 0, 0, [], 0
for m in re.finditer(r"<(/?)table\b", h):
    if not m.group(1):
        if depth == 0: start = m.start()
        depth += 1
    else:
        depth -= 1
        if depth == 0:
            end = h.index(">", m.end()) + 1
            t = h[start:end]
            if "Public domain" in t or "public domain" in t:
                pieces.append(h[last:start]); last = end; continue
            cols = max((len(re.findall(r"<t[dh]\b", r)) for r in re.split(r"<tr\b", t)[1:]), default=0)
            ty = typst(t)
            # equal shares from the HTML become content widths; a cell opening with = is text, not a heading
            ty = re.sub(r"columns: \(([\d.]+%)(, \1)*\),", lambda mm: "columns: (" + "auto, " * (mm.group(0).count("%")) + "),", ty)
            ty = re.sub(r"\[(\s*)= ", r"[\1\\= ", ty)
            ty = re.sub(r"FNMARK([\w-]+)FNEND", lambda mm: "#footnote[" + note_typ(mm.group(1)) + "]", ty)
            used_in_tables.update(re.findall(r"FNMARK([\w-]+)FNEND", t))
            wrap = "vb-turned" if cols >= 12 else "vb-small-table"
            moved = re.findall(r"PGMARK\d+PGEND", ty)      # a source page that begins inside a table: marked after it
            ty = re.sub(r"PGMARK\d+PGEND", "", ty)
            tables.append(f"```{{=typst}}\n#{wrap}[\n{ty}\n]\n```" + ("\n\n" + "".join(moved) if moved else ""))
            pieces.append(h[last:start] + f"<p>TBLMARK{len(tables) - 1}TBLEND</p>"); last = end
pieces.append(h[last:]); h = "".join(pieces)
md = pandoc(h)
md = re.sub(r"TBLMARK(\d+)TBLEND", lambda m: tables[int(m.group(1))], md)
md = re.sub(r'PGMARK(\d+)PGEND', r'[p. \1]', md)
md = re.sub(r'FNMARK([\w-]+)FNEND', lambda m: f'[^{prefix}-{m.group(1)}]', md)
md += "\n\n" + "\n\n".join(f"[^{prefix}-{k}]: " + v.replace("\n\n", "\n\n    ") for k, v in notes.items() if k not in used_in_tables) + "\n"
open(out, "w", encoding="utf-8").write(md)
print(out, len(md.split()), "words,", len(notes), "notes")
