#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
"""Render the gallery images in docs/img from the specimen built in every template.

    python3 docs/src/gallery.py [--kuki PATH-TO-KUKI-PDF] [--kuki-wild PATH]

Run `./vbook samples examples/specimen` first. Needs pdftoppm and typst. Pages from the specimen only,
except the Kuki covers, which carry no translation text.
"""
import argparse
import subprocess
import tempfile
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO = HERE.parent.parent
IMG = REPO / "docs" / "img"
SAMPLES = REPO / "examples" / "specimen" / "build" / "samples"
TEMPLATES = ["classic", "modern", "kintsugi", "wildcard"]
PALETTES = [("mint-pink", "#0d0d0d"), ("acid", "#0d0d0d"), ("sand-sky", "#0d0d0d"), ("coral", "#0d0d0d"),
            ("electric", "#1a1aff"), ("mono", "#0d0d0d")]


def run(*cmd):
    subprocess.run(cmd, check=True, capture_output=True, text=True)


def page_png(pdf, page, out, ppi=150, crop=None):
    args = ["pdftoppm", "-r", str(ppi), "-png", "-f", str(page), "-l", str(page), "-singlefile"]
    if crop:
        x, y, w, h = (int(v * ppi / 72) for v in crop)
        args += ["-x", str(x), "-y", str(y), "-W", str(w), "-H", str(h)]
    run(*args, str(pdf), str(out.with_suffix("")))
    return out


def pages_of(pdf):
    out = subprocess.run(["pdfinfo", str(pdf)], capture_output=True, text=True).stdout
    return int(next(l.split()[-1] for l in out.splitlines() if l.startswith("Pages")))


def find(pdf, words, start=8):
    for p in range(start, pages_of(pdf) + 1):
        t = subprocess.run(["pdftotext", "-f", str(p), "-l", str(p), str(pdf), "-"], capture_output=True, text=True).stdout
        t = " ".join(t.split())[:200].lower().replace("- ", "")
        if any(w.lower() in t for w in words):
            return p
    raise SystemExit(f"{pdf.name}: none of {words} found")


def compose(typ, out, tmp, ppi=180):
    src = tmp / (out.stem + ".typ")
    src.write_text(typ, encoding="utf-8")
    run("typst", "compile", "--root", "/", "--format", "png", "--ppi", str(ppi), str(src), str(out))


GROUND = 'rgb("#e7e3da")'


def spread(left, right, out, tmp):
    """Two pages face to face, with a soft shadow at the spine."""
    typ = f"""#set page(width: auto, height: auto, margin: 26pt, fill: {GROUND})
#box(stroke: 0.6pt + luma(175), stack(dir: ltr,
  box(image("{left}", width: 130mm)) + place(top + right, rect(width: 9mm, height: 100%, stroke: none,
    fill: gradient.linear(luma(255, 0%), luma(0, 14%)))),
  box(image("{right}", width: 130mm)) + place(top + left, rect(width: 9mm, height: 100%, stroke: none,
    fill: gradient.linear(luma(0, 16%), luma(255, 0%))))))
"""
    compose(typ, out, tmp)


def row(images, out, tmp, width=60, labels=None):
    cells = []
    for i, p in enumerate(images):
        cell = f'box(stroke: 0.6pt + luma(175), image("{p}", width: {width}mm))'
        if labels:
            cell = f'stack(spacing: 7pt, {cell}, text(9pt, font: "Fira Sans", stretch: 75%, fill: luma(60), "{labels[i]}"))'
        cells.append(cell)
    typ = f"""#set page(width: auto, height: auto, margin: 26pt, fill: {GROUND})
#stack(dir: ltr, spacing: 14pt, {", ".join(cells)})
"""
    compose(typ, out, tmp)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--kuki", help="classic Kuki PDF (covers only)")
    ap.add_argument("--kuki-wild", help="wildcard Kuki PDF (covers only)")
    a = ap.parse_args()
    IMG.mkdir(parents=True, exist_ok=True)
    with tempfile.TemporaryDirectory() as t:
        tmp = Path(t)
        covers, labels = [], []
        for name in TEMPLATES:
            pdf = SAMPLES / f"{name}.pdf"
            ch2 = find(pdf, ["Figures, Schemes", "FIGURES, SCHEMES", "SCHEMES AND"])
            l = page_png(pdf, ch2 - 1, tmp / f"{name}-l.png", 240)
            r = page_png(pdf, ch2, tmp / f"{name}-r.png", 240)
            spread(l, r, IMG / f"spread-{name}.png", tmp)
            ch1 = find(pdf, ["Conventions of the Text", "CONVEN"])
            l = page_png(pdf, ch1, tmp / f"{name}-c1.png", 240)
            r = page_png(pdf, ch1 + 1, tmp / f"{name}-c2.png", 240)
            spread(l, r, IMG / f"opening-{name}.png", tmp)
            covers.append(page_png(pdf, 1, tmp / f"{name}-cover.png", 200))
            labels.append(name)
        if a.kuki:
            covers.append(page_png(Path(a.kuki), 1, tmp / "kuki-cover.png", 200)); labels.append("classic: Kuki, frame cover")
        if a.kuki_wild:
            covers.append(page_png(Path(a.kuki_wild), 1, tmp / "kuki-wild-cover.png", 200)); labels.append("wildcard: Kuki, field cover")
        row(covers, IMG / "covers.png", tmp, width=52, labels=labels)
        pdf = SAMPLES / "classic.pdf"
        prelims = [page_png(pdf, p, tmp / f"pre-{p}.png", 220) for p in (3, 4, 5)]
        row(prelims, IMG / "prelims.png", tmp, width=72, labels=["title page", "imprint page", "contents"])
        wpdf = SAMPLES / "wildcard.pdf"
        wl = [page_png(wpdf, p, tmp / f"w-{p}.png", 220) for p in (3, 5)]
        last = pages_of(wpdf)
        wl.append(page_png(wpdf, last, tmp / "w-back.png", 220))
        row(wl, IMG / "wildcard-pages.png", tmp, width=62, labels=["title page", "contents", "back cover"])
        # the wildcard in every palette: cover above, first field page below
        import shutil
        cells = []
        for pal, ink in PALETTES:
            d = tmp / f"pal-{pal}"
            shutil.copytree(REPO / "examples" / "specimen", d, ignore=shutil.ignore_patterns("build", "book"))
            toml = (d / "book.toml").read_text(encoding="utf-8")
            toml = toml.replace('template = "classic"', f'template = "wildcard"\nfield-palette = "{pal}"\nfield-ink = "{ink}"')
            toml = toml.replace('cover = "frame"', 'cover = "field"')
            (d / "book.toml").write_text(toml, encoding="utf-8")
            run(str(REPO / "vbook"), "build", str(d))
            bp = d / "book" / "specimen.pdf"
            c = page_png(bp, 1, tmp / f"pal-{pal}-c.png", 160)
            f = page_png(bp, find(bp, ["PREFACE"]) - 1, tmp / f"pal-{pal}-f.png", 160)
            cells.append(f'stack(spacing: 8pt, box(stroke: 0.6pt + luma(175), image("{c}", width: 44mm)), '
                         f'box(stroke: 0.6pt + luma(175), image("{f}", width: 44mm)), '
                         f'text(9pt, font: "Fira Sans", stretch: 75%, fill: luma(60), "{pal}"))')
        compose(f"""#set page(width: auto, height: auto, margin: 26pt, fill: {GROUND})
#stack(dir: ltr, spacing: 12pt, {", ".join(cells)})
""", IMG / "palettes.png", tmp)
        # details, at print resolution
        p = find(pdf, ["Conventions of the Text"])
        page_png(pdf, p, IMG / "detail-margin.png", 300, crop=(52, 168, 386, 128))
        p = find(pdf, ["Figures, Schemes"])
        page_png(pdf, p, IMG / "detail-figure.png", 300, crop=(60, 280, 330, 230))
        page_png(pdf, p + 1, IMG / "detail-scheme.png", 300, crop=(60, 40, 330, 210))
        page_png(wpdf, find(wpdf, ["SCHEMES AND", "FIGURES, SCHEMES"]) - 1, IMG / "detail-field.png", 200, crop=(40, 160, 290, 230))
    print("docs/img: gallery written")


if __name__ == "__main__":
    main()
