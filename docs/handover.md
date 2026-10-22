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

1. **Text gate.** The translation checks pass on the text (pages continuous, notes paired, banned words, glossary counts), and the translator signs the text off in `STATUS.md`.
2. **Build early.** Before the gate, build from the first merged chapter and after every merge. A partial manifest is fine: globs take whatever files exist.
3. **Design.** `vbook samples` sets the book in each template; the translator chooses, and the choice goes in `[design]` and the decisions log in `STATUS.md`.
4. **Build and check.** `vbook check <folder> --report` writes the PDF to `book/` and `book/BUILD.md`: date, Vector Book version, template, page count, notes and figures set against the sources, missing glyphs, long captions without a key, and the files in order. Commit both.
5. **Proof.** Faults in the text go back as change lists in the method's format (`### readable | p. N`, `OLD`, `NEW`, `WHY`) and are applied by the translation side to the literal and readable masters together. Faults in the layout are fixed in `book.toml` or in Vector Book.
6. **Rebuild** after each round, and run the translation side's check of the PDF (below), until the book gate is passed.

## Returns

When the book side finds a fault, it sends a return: one file per round, `proof/return-NN.md` in the book folder, committed and kept with the book like the decisions log. `vbook return <folder>` runs the check and writes the next file with every fault the checks can locate; items from proof are added by hand below them. A blank is in `starter/proof/return.md`.

**Header.** Book, round, date, Vector Book commit, build result, handover state (`[sources] handover = "partial"` or `"final"`), and status: OPEN (the book side has written it), ANSWERED (the translation side has responded, applied, rebuilt), CLOSED (the book side has rebuilt and accepts), or OPEN again with items reopened.

**Items** are numbered R1, R2, … within the file; elsewhere they are cited as `return-02 R3`. Each has a kind, a location, how it was found, the evidence, an optional proposed change, the translation side's response and the book side's closing line.

| Kind | What | Who acts |
|---|---|---|
| MARKUP | The form of the text, not its wording: heading form, note labels (duplicate, unreferenced, undefined), a page marker out of place, a figure line, a caption without `Key:`, a section break or scheme written another way | Translation side applies; the book side may propose the exact change |
| TEXT | Wording: an apparent misprint, typo or dropped word seen in proof | Translation side checks against the literal and the source, and applies |
| QUERY | A choice only the translator can make, which the layout exposes: a title too long for a running head, a note longer than a page, a word that breaks badly | The translator decides |
| SOURCES | A file or table the translation side owns: `[book]`, `[sources]`, `[markers]`, `glossary.csv`, the figures manifest, a missing image or file | Translation side |
| LAYOUT | The book side's own fault, fixed in Vector Book or `[design]`: fonts, spacing, breaks | Book side; recorded for the trail |
| OTHER | A case that fits none of the above, with a one-line description of what happened | The translator, as for a QUERY, until the two sides agree its kind or what to do |

**Where** gives the file and line, the source page (`after [p. N]`) and, for proof items, the PDF page. Lines move when the text is edited, so the source page and the quoted text are the anchors that last. No item without a location.

**Proposed** (MARKUP and TEXT, optional) is a change-list entry in the method's format (`### readable | p. N`, `OLD`, `NEW`, `WHY`), with an `OLD` that matches once.

**Response**, written by the translation side under each item: FIXED (with the commit, and whether the literal changed too), CHANGED-OTHERWISE (what was done and why), QUERY-TO-TRANSLATOR (with the date asked), DECLINED (with the reason, e.g. the source prints it so), or NOTED (LAYOUT items). **Book side** closes each item after the rebuild: CLOSED, or REOPENED with the reason.

**Rules**
1. The book side never edits `text/`, `front/`, `back/` or `glossary.csv`. It describes and proposes. The translation side applies changes to the literal and readable masters together (literal first, the readable from it), with `vt_apply.py`.
2. Every item says exactly where, so that it can be found without the person who reported it.
3. The translator decides every QUERY and every OTHER; neither side settles one. When the same kind of OTHER case recurs, it gets a kind of its own, added to this table.
4. The translation side answers every item, reruns `vbook check --report`, commits, and sets ANSWERED. The book side rebuilds and sets CLOSED, or reopens items with a reason.
5. A return against a partial handover deals only with what is built; faults in unfinished parts wait for the next handover.
6. Each side tells the other when a return is opened or answered. The file is the record.

## Checks from the translation side

The translation side checks the built book independently of Vector Book. `vt_bookcheck.py <folder>` (in the translation tools) extracts the PDF's text and compares it with the translation's own source files: every body word in order, every note and every heading, each difference located by file and source page. It runs when the translator asks, before a return is marked ANSWERED, and before sign-off.

Its findings are recorded as `proof/check-NN.md`, the counterpart of `return-NN.md`, in the same format with the direction reversed. Its items are LAYOUT items addressed to the book side, which writes the Response lines and rebuilds. The translation side writes the closing line for each item, and the file's status. A check with no findings is recorded as CLOSED.

## Book gate

A book is ready for the translator's sign-off when:

1. `book/BUILD.md` is clean: notes and figures all set, no missing glyphs;
2. the latest `vt_bookcheck.py` run has no open findings;
3. every `return-NN.md` and every `check-NN.md` in `proof/` is CLOSED.

The translator then signs off the book in `STATUS.md`, with the date, the Vector Book commit from `BUILD.md`, and the PDF. Identifiers come last: when a book is published, its ISBN and DOI go into `[book] isbn` and `doi`, and the book is rebuilt and checked once more before release. Legal deposit is an option at the end, decided per book.

## Running the tool

Vector Book stays in its own repository and is called by path; nothing is copied into the book's repository:

```bash
path/to/vector-book/vbook check path/to/book --report
```

`BUILD.md` records the Vector Book commit, so a book can be rebuilt with the same version. Needs Python 3.11+, Pandoc 3, Typst 0.13 or later, and the template's fonts (`vbook fonts`).

## Not yet

A facing-page layout with the literal beside the readable version, and the literal as an appendix, are planned. Until then only the readable version is typeset.
