<p align="center"><img src="brand/mark-full-paper.svg" alt="Vector Book mark: Leonardo's cube, opened as a book" width="160"></p>

<h1 align="center">Vector Book</h1>
<p align="center">Book design and typesetting for vector humanities editions and translations<br>
<sub>A Vector Humanities tool · alpha · GPL-3.0</sub></p>

---

Vector Book typesets a book from Markdown section files. A short `book.toml` describes the book; `vbook build` assembles the sections, passes them through Pandoc with a Lua filter, and sets them in Typst. The design comes from the vector translation of Kuki Shūzō's 偶然性の問題 (*The Problem of Contingency*, 1935): Royal octavo, EB Garamond, centred small-capital headings, and the source edition's page numbers in the outer margin.

<p align="center"><img src="docs/img/specimen-spread.png" alt="Specimen spread: a chapter opening with a figure and English glosses over its Japanese labels" width="720"></p>

## Use

Needs Python 3.11+, Pandoc 3 and Typst 0.13 or later.

```bash
./vbook new mybook          # start from the starter project
./vbook build mybook        # assemble, convert, compile
./vbook check mybook        # notes and figures set against the sources; missing glyphs
./vbook sweep mybook        # every non-ASCII character, checked for font fallback
./vbook proof mybook        # contact sheet of the pages
./vbook fonts mybook        # the font stacks, and which are installed
```

The specimen in [`examples/specimen/`](examples/specimen/) shows every convention and builds to [`examples/specimen/book/specimen.pdf`](examples/specimen/book/specimen.pdf).

## Status

First version, October 2026. The full Kuki book builds through it (all 473 notes and 22 figures set, no missing glyphs). Documentation of the conventions and configuration, the practices distilled from the Kuki book, further templates and a facing-page layout are in progress.
