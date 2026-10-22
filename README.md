<p align="center"><img src="brand/mark-full-paper.svg" alt="Vector Book mark: Leonardo's cube, opened as a book" width="160"></p>

<h1 align="center">Vector Book</h1>
<p align="center">Book design and typesetting for vector humanities editions and translations<br>
<sub>A Vector Humanities tool · alpha · GPL-3.0 · <a href="https://vector-humanities.github.io/vector-book/">vector-humanities.github.io/vector-book</a></sub></p>

---

Vector Book typesets a book from Markdown section files. A short `book.toml` describes the book; `vbook build` assembles the sections, passes them through Pandoc with a Lua filter, and sets them in Typst. Its first design was made for the vector translation of Kuki Shūzō's 偶然性の問題 (*The Problem of Contingency*, 1935): Royal octavo, EB Garamond, centred small-capital headings, and the source edition's page numbers in the outer margin. Five designs are available, and every book can be set in all of them with one command.

<p align="center"><img src="docs/img/covers.png" alt="Covers: the specimen in the classic, modern, kintsugi, organic and vectors designs, and the Kuki book with its frame, field and vector covers" width="100%"></p>

## Five designs

**Classic.** The design chosen for Kuki. EB Garamond at 10.5 pt on a 156 × 234 mm page; centred small-capital headings; the printed source's page numbers set small in the outer margin, on the baseline of the line where each page begins; notes restarting with each chapter under a short rule.

<p align="center"><img src="docs/img/spread-classic.png" alt="Classic: the end of chapter 1 and the opening of chapter 2, with a figure carrying English glosses over its Japanese labels" width="100%"></p>
<p align="center"><img src="docs/img/opening-classic.png" alt="Classic: the opening of chapter 1, with section headings, notes and margin page numbers" width="100%"></p>

**Modern.** Source Serif 4 for the text, Source Sans 3 semibold for headings in navy, set flush left; source pages inline as small grey `[N]`; a full-width rule above the notes.

<p align="center"><img src="docs/img/spread-modern.png" alt="Modern: the end of chapter 1 and the opening of chapter 2" width="100%"></p>
<p align="center"><img src="docs/img/opening-modern.png" alt="Modern: the opening of chapter 1" width="100%"></p>

**Kintsugi.** Crimson Pro with Shippori Mincho; centred headings in gold; section numbers as kanji (一, 二, …); gold hairlines under the running head and above the notes; figures set between gold rules.

<p align="center"><img src="docs/img/spread-kintsugi.png" alt="Kintsugi: the end of chapter 1 and the opening of chapter 2, the figure between gold rules" width="100%"></p>
<p align="center"><img src="docs/img/opening-kintsugi.png" alt="Kintsugi: the opening of chapter 1" width="100%"></p>

**Organic.** A 130 × 190 mm paperback in the manner of contemporary theory publishing. Fira Sans Condensed for the text; chapter titles in huge Archivo capitals, stacked and broken across lines; before every chapter, a field page generated from the book itself, regions of black, colour and white stipple drawn from a noise surface seeded by the book's title, so that no two books and no two chapters share a field; a field cover; a huge Contents; a black back cover.

<p align="center"><img src="docs/img/spread-organic.png" alt="Organic: a generated field page facing the opening of chapter 2, set in huge stacked capitals" width="100%"></p>
<p align="center"><img src="docs/img/opening-organic.png" alt="Organic: the opening of chapter 1, its title broken across four lines" width="100%"></p>
<p align="center"><img src="docs/img/organic-pages.png" alt="Organic: title page, Contents and black back cover" width="100%"></p>

The organic design's colours are chosen in `book.toml`: six palettes, or your own list, and the ink of the solid regions. On the cover the ink opens around the title, so the title never stands on black.

<p align="center"><img src="docs/img/palettes.png" alt="The organic cover and a field page in six palettes: mint and pink, acid, sand and sky, coral, electric with blue ink, and black and white" width="100%"></p>

**Vectors.** A 140 × 216 mm book drawn from vector spaces. IBM Plex Serif for the text, Bricolage Grotesque for headings, IBM Plex Mono for running heads, labels and source pages. Every chapter opens under a band of generated imagery with its title set large over it, and before every chapter stands a full page of it: streamlines, arrow fields, tensor glyphs drawn along the flow, a coordinate grid bent by the flow into a manifold, point clouds with labelled basis vectors. All of it comes from one flow field per page, seeded by the book's title and the chapter's place in it. Every other page inverts the palette. Type over imagery carries a halo in the ground colour, so it reads on any palette.

<p align="center"><img src="docs/img/spread-vectors.png" alt="Vectors: a generated page of vector imagery facing the opening of chapter 2, its title set large over a band of streamlines" width="100%"></p>
<p align="center"><img src="docs/img/opening-vectors.png" alt="Vectors: the opening of chapter 1 under its band" width="100%"></p>
<p align="center"><img src="docs/img/vectors-pages.png" alt="Vectors: title page, Contents and back cover" width="100%"></p>

Five palettes (`vector-palette`: electric, night, blueprint, garden, spectrum), or your own ground, ink and colours:

<p align="center"><img src="docs/img/palettes-vectors.png" alt="The vectors cover and a chapter opening in five palettes" width="100%"></p>

## Front matter

Cover, frontispiece, title page, an imprint page (publisher and series, edition, copyright and moral rights, licence, third-party material, AI disclosure, cataloguing, ISBN per format, DOI, and a typesetting line Vector Book writes from the faces the book's characters reach), Contents and List of Figures, all from `book.toml`.

<p align="center"><img src="docs/img/prelims.png" alt="Classic: title page, imprint page and Contents" width="100%"></p>

## Details

Source page numbers in the margin, set on the baseline of the line where the source page begins:

<p align="center"><img src="docs/img/detail-margin.png" alt="Detail: a margin page number beside the first line of a source page" width="100%"></p>

Figures at the size they had in the source, with English glosses laid over their labels and a key beneath; a note in the caption stays in the text and out of the List of Figures:

<p align="center"><img src="docs/img/detail-figure.png" alt="Detail: a figure with English glosses over its Japanese labels, caption and key" width="100%"></p>

Schemes joined by a brace, and tables that break across pages with their columns sized to their contents:

<p align="center"><img src="docs/img/detail-scheme.png" alt="Detail: a scheme with a brace, and a table" width="100%"></p>

A generated field, at print resolution:

<p align="center"><img src="docs/img/detail-field.png" alt="Detail: part of a generated field, black regions with white stipple, a dotted contour, colour" width="100%"></p>

## Use

Needs Python 3.11+, Pandoc 3, Typst 0.13 or later, and the template's fonts (`vbook fonts` lists them; all but Hiragino are open fonts).

```bash
./vbook new mybook          # start from the starter project
./vbook build mybook        # assemble, convert, compile
./vbook check mybook        # notes and figures set against the sources; missing glyphs (--report: book/BUILD.md)
./vbook sweep mybook        # every non-ASCII character, checked for font fallback
./vbook proof mybook        # contact sheet of the pages
./vbook samples mybook      # the book in every template, matching pages side by side
./vbook return mybook       # check, then write proof/return-NN.md for the translation side
./vbook fonts mybook        # the font stacks, and which are installed
```

The specimen in [`examples/specimen/`](examples/specimen/) shows every convention and builds to [`examples/specimen/book/specimen.pdf`](examples/specimen/book/specimen.pdf). The gallery images are made by [`docs/src/gallery.py`](docs/src/gallery.py) from the specimen built in every template.

## Documentation

| | |
|---|---|
| [`docs/conventions.md`](docs/conventions.md) | What the Markdown says: chapters, page markers, notes, insertions, verse, figures and overlays, schemes, breaks, tables, glossary |
| [`docs/config.md`](docs/config.md) | Every key in `book.toml`, and the five templates |
| [`docs/handover.md`](docs/handover.md) | How a finished vector translation passes to Vector Book: the book folder, the manifest, returns and checks, the book gate |
| [`docs/practice.md`](docs/practice.md) | How to make a book, from what the Kuki book needed, with the faults met and how the tool handles them |
| [`AGENTS.md`](AGENTS.md) | Instructions for agents working on this repository |

Vector Book is stage 7 of the Vector Translation method, and serves editions as well as translations.

## Layout

```
vbook                command
lib/                 Pandoc Lua filter, shared Typst functions, the field and vector generators
templates/           page designs: classic, modern, kintsugi, organic, vectors
covers/              frame, plain, field and vector covers
starter/             the project vbook new copies
examples/specimen/   a book that uses every convention
docs/                documentation, gallery images, the site
brand/               the mark and its generator
```

## Status

Alpha, October 2026. The full Kuki book builds in every design: 473 notes and 22 figures set, no missing glyphs (classic 242 pp., organic 284 pp., vectors 300 pp.). To come: a facing-page layout for literal and readable versions, EPUB and HTML output, and open CJK fonts for builds away from macOS.

Created by David M. Berry. Licence: GNU General Public License, version 3 or later.
