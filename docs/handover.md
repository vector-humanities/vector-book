# From translation to book

How a finished vector translation passes to Vector Book. Agreed with the Vector Translation method, where this is stage 7 (`vt-book`).

## The book folder

The translation side keeps one folder per book. Vector Book reads it in place and never edits the text.

```
book.toml              the manifest (below)
front/NN-*.md          Preface, Translator's Note, author's preface
text/readable/NN-*.md  the text, one file per section, in reading order
text/literal/NN-*.md   the literal version (not typeset)
back/NN-*.md           appendices
glossary.csv           source, reading, english, competitors, scope, decided, notes
figures/               images, FIGURES.md, overlays.json
source/pages/          page images, for figures and covers
book/                  the PDF and BUILD.md (written by Vector Book)
build/                 working files (written by Vector Book; ignore it in git)
```

## The manifest

`book.toml` (format in [config.md](config.md); a blank one in `starter/book.toml`). TOML is read by Python's standard library, so neither side installs a parser. The two sides own different tables.

| Table | Written by | Holds |
|---|---|---|
| `[book]` | translation | Title, subtitle, author, original title, credit line ("A Vector Translation Project by …"), affiliation, and `credits`: the edition translated with its library and identifier, image credit, rights line, conventions note |
| `[sources]` | translation | Order: `front`, `body`, `back` as globs (`text/readable/*.md`) or lists of files; `glossary`; `overlays` |
| `[markers]` | translation | The page-marker pattern, and patterns to strip (image numbers) |
| `[design]` | design | Template (chosen from `vbook samples`), cover, notes per chapter or through the book, protected words, font overrides |
| `[cover]`, `[back]`, `[frontispiece]` | design | Cover text and colours, portrait, quotation, blurb |

Vector Book reads the section files the manifest names directly, dropping `<!-- working -->` blocks as `vt_assemble.py` does, so there is no assembled copy to fall out of date. A book that prefers the assembled file can name it instead (`body = ["build/readable.md"]`) and run `vt_assemble.py` before each build.

Nothing about scripts or languages needs declaring: `vbook sweep` reads every character in the text and checks it against the template's font stack.

## What the text must carry

- At most one level-one heading per section file, with its attributes: `# Title {num="Chapter 1" orig="原題" run="Short title"}`. A file without one continues the chapter before it, so a text whose sections come back from separate agents can keep one file per section under a single chapter heading.
- Footnote labels unique across the whole book, prefixed by section (`[^c3s8-4]`).
- `[p. N]` page markers in the pattern `[markers]` names.
- Figures as an image line and a `**Figure N.**` caption, with `Key:` or `Labels:` before any key; paths relative to the book folder.
- Section breaks as a paragraph of asterisks or dots alone (`* * *`, `· · ·`), set as written.
- Schemes, signatures and other layout as in [conventions.md](conventions.md) (`::: scheme`, `::: right`, `::: break`).
- A note on a text's title goes on the heading: `# Title[^label] {…}`.

Page markers give every passage a stable reference for proof corrections; no further passage identifiers are needed.

## The flow

1. **Gate.** The translation checks pass on the text (pages continuous, notes paired, banned words, glossary counts), and the translator signs the text off in `STATUS.md`.
2. **Build early.** Before the gate, build from the first merged chapter and after every merge. A partial manifest is fine: globs take whatever files exist.
3. **Design.** `vbook samples` sets the book in each template; the translator chooses, and the choice goes in `[design]` and the decisions log in `STATUS.md`.
4. **Build and check.** `vbook check <folder> --report` writes the PDF to `book/` and `book/BUILD.md`: date, Vector Book version, template, page count, notes and figures set against the sources, missing glyphs, long captions without a key, and the files in order. Commit both.
5. **Proof.** Faults in the text go back as change lists in the method's format (`### readable | p. N`, `OLD`, `NEW`, `WHY`) and are applied by the translation side to the literal and readable masters together. Faults in the layout are fixed in `book.toml` or in Vector Book.
6. **Rebuild** after each round, until the translator signs off the book.

## Running the tool

Vector Book stays in its own repository and is called by path; nothing is copied into the book's repository:

```bash
path/to/vector-book/vbook check path/to/book --report
```

`BUILD.md` records the Vector Book commit, so a book can be rebuilt with the same version. Needs Python 3.11+, Pandoc 3, Typst 0.13 or later, and the template's fonts (`vbook fonts`).

## Not yet

A facing-page layout with the literal beside the readable version, and the literal as an appendix, are planned. Until then only the readable version is typeset.
