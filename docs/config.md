# book.toml

Every key, with its default. Strings marked *Markdown* may use emphasis and line breaks; multi-paragraph values use TOML's triple quotes. Lengths are Typst lengths (`156mm`, `10.5pt`); colours are `#rrggbb`.

## [book]

| Key | Default | |
|---|---|---|
| `title` | `"Untitled"` | *Markdown.* Title page, covers, document metadata |
| `subtitle` | none | *Markdown.* Title page and plain cover |
| `author` | none | *Markdown.* Set in spaced capitals above the title |
| `original-title` | none | The title in the source language |
| `running-title` | `title` | Running head on versos |
| `credit` | none | *Markdown.* Title page and covers, e.g. "A Vector Translation Project by …" |
| `affiliation` | none | Back cover, under the credit |
| `credits` | none | *Markdown, paragraphs.* The page facing the title page: edition translated, library and identifier, image credits, conventions |
| `lang`, `region` | `"en"`, `"gb"` | Hyphenation and quotation marks |
| `output` | `"book/book.pdf"` | Where the PDF is written |

## [design]

| Key | Default | |
|---|---|---|
| `template` | `"classic"` | Page design; see `templates/` |
| `cover` | `"frame"` | `frame` (ruled frame with vertical text, after the 1948 Iwanami title page) or `plain` |
| `page` | the template's | Table of `width`, `height`, `inside`, `outside`, `top`, `bottom`, `size` (body type size) |
| `fonts.text` | the template's | Font stack for the text, in order of preference |
| `fonts.mono` | the template's | Font stack for code |
| `no-hyphen` | `[]` | Words never broken at a line end |
| `end-blanks` | `0` | Pages marked "Page left deliberately blank" before the back cover |
| `figure-dpi` | `300` | Resolution at which figure images are sized |

The classic template's defaults: 156 × 234 mm (Royal octavo); margins inside 22, outside 26, top 22, bottom 24 mm; 10.5 pt; text stack EB Garamond 12, Gentium Book Plus, Hiragino Mincho ProN, Noto Serif JP, STIX Two Text, STIX Two Math, Apple Symbols; mono stack Menlo, DejaVu Sans Mono, Hiragino Mincho ProN.

Each character is set in the first font of the stack that has it. Put the Latin face first, then a face with full diacritics and Greek, then the CJK face, then symbols. Run `vbook sweep` after any change to the stack or the text's character set.

## [sources]

| Key | Default | |
|---|---|---|
| `front` | `[]` | Glob patterns for front-matter files (Preface, Translator's Note) |
| `body` | `["text/*.md"]` | Glob patterns for the text |
| `back` | `[]` | Glob patterns for appendices |
| `glossary` | none | CSV file set as the last chapter |
| `glossary-columns` | `["source", "reading", "english"]` | CSV columns to set |
| `glossary-headers` | `["Source", "Reading", "English"]` | Their headings |
| `glossary-title` | `"Glossary"` | |
| `overlays` | `"figures/overlays.json"` | Figure glosses; a missing file means none |
| `parse-headings` | `false` | Read `Chapter N. Title (原題)` headings (see [conventions.md](conventions.md#chapters)) |
| `shift-headings` | `0` | Added to every heading level; `-1` when chapters are `##` |
| `bibliography` | none | A bibliography file for Pandoc's citeproc |
| `csl` | none | A CSL style for it |

## [markers]

| Key | Default | |
|---|---|---|
| `page` | `'\[p\. (\d+)\]'` | Regular expression for a source page marker; group 1 is the number set in the margin |
| `strip` | `[]` | Regular expressions removed from the book, e.g. `'\[コマ [^\]]*\]'` for image numbers |

Use TOML's single-quoted strings for regular expressions, so that backslashes are kept.

## [frontispiece]

Optional. A page facing the title page.

| Key | |
|---|---|
| `image` | Path to the image |
| `width` | Default `56mm` |
| `caption` | *Markdown* |

## [cover]

| Key | Default | |
|---|---|---|
| `paper`, `ink`, `accent` | `#efe8d8`, `#1f1b16`, `#a8873c` | Cover colours; `accent` for the rule on the back |
| `frame` | none | For the frame cover: `{ left = "英譯", centre = "偶然性の問題", right = "九鬼周造著" }`, set as vertical columns; the centre in bold |

Follow the typography of the edition translated, but do not reproduce a publisher's name the edition does not carry.

## [back]

| Key | |
|---|---|
| `portrait` | `{ image = "…", width = "30mm", caption = "…" }` |
| `quote` | *Markdown.* A short passage from the book |
| `quote-source` | *Markdown* |
| `blurb` | *Markdown, paragraphs* |

## Fonts folder

A `fonts/` folder in the book folder is passed to Typst with `--font-path`, so a book can carry its own open fonts.
