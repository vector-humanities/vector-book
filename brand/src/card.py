#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-3.0-or-later
"""Render the vectors-style share card, brand/card-vectors-1200x630.png, 120 × 63 mm at 254 ppi.

    python3 brand/src/card.py [palette] [seed]

Imagery from lib/vectorfields.py, title in Bricolage Grotesque, lines in IBM Plex Mono. Needs typst.
"""
import subprocess
import sys
import tempfile
from pathlib import Path

REPO = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO / "lib"))
from vectorfields import PALETTES, vector_svg  # noqa: E402

W, H = 120.0, 63.0
palette = sys.argv[1] if len(sys.argv) > 1 else "night"
seed = sys.argv[2] if len(sys.argv) > 2 else "vector-book-card"
pal = PALETTES[palette]

TYP = """
#set page(width: {W}mm, height: {H}mm, margin: 0mm, fill: rgb("{ground}"),
  background: image("field.svg", width: 100%, height: 100%))
#let ground = rgb("{ground}")
#let ink = rgb("{ink}")
#let accent = rgb("{accent}")
#let mono = ("IBM Plex Mono",)
#let halo(body, t: 1.6pt) = box({{
  place(text(fill: ground, stroke: (paint: ground, thickness: t, join: "round"), body))
  text(fill: ink, body)
}})
#set text(fill: ink, hyphenate: false)
#place(top + left, dx: 5.4mm, dy: 5.4mm, box(fill: ground, inset: (x: 1.6mm, y: 1.2mm), text(5.6pt, font: mono, tracking: 0.18em, weight: "medium")[VECTOR HUMANITIES]))
#place(left + horizon, dx: 6.2mm, dy: -1.5mm, block({{
  set par(leading: 0.02em)
  let t = text.with(43pt, font: ("Bricolage Grotesque 96pt", "Space Grotesk"), weight: 800, tracking: -0.025em)
  place(top + left, t(fill: ground, stroke: (paint: ground, thickness: 3.4pt, join: "round"))[Vector \\ Book])
  t(fill: ink)[Vector \\ Book]
}}))
#let label(body) = box(fill: ground, inset: (x: 1.6mm, y: 1.2mm), text(5.6pt, font: mono, body))
#place(bottom + left, dx: 5.4mm, dy: -5.4mm, stack(spacing: 0.8mm,
  label[Book design and typesetting from Markdown],
  label(text(fill: accent)[→ ] + [classic · modern · kintsugi · organic · vectors])))
"""


def main():
    with tempfile.TemporaryDirectory() as tmp:
        tmp = Path(tmp)
        # drawn at 1.5 times the card's size so the strokes come out finer
        k = 1.5
        svg = vector_svg(seed, W * k, H * k, pal, layers=("grid", "streamlines"))
        (tmp / "field.svg").write_text(svg, encoding="utf-8")
        (tmp / "card.typ").write_text(TYP.format(W=W, H=H, ground=pal["ground"], ink=pal["ink"],
                                                accent=pal["colours"][0]), encoding="utf-8")
        out = REPO / "brand" / "card-vectors-1200x630.png"
        subprocess.run(["typst", "compile", "--format", "png", "--ppi", "254", str(tmp / "card.typ"), str(out)], check=True)
        print(out)


if __name__ == "__main__":
    main()
