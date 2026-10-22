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
| `credits` | none | *Markdown, paragraphs.* About this edition, at the foot of the imprint page: edition translated, library and identifier, image credits, conventions |
| `lang`, `region` | `"en"`, `"gb"` | Hyphenation and quotation marks |
| `output` | `"book/book.pdf"` | Where the PDF is written |

## [design]

| Key | Default | |
|---|---|---|
| `template` | `"classic"` | Page design: `classic`, `modern` or `kintsugi` (see Templates below) |
| `cover` | `"frame"` | `frame` (ruled frame with vertical text, after the 1948 Iwanami title page) or `plain` |
| `page` | the template's | Table of `width`, `height`, `inside`, `outside`, `top`, `bottom`, `size` (body type size) |
| `fonts.text` | the template's | Font stack for the text, in order of preference |
| `fonts.mono` | the template's | Font stack for code |
| `no-hyphen` | `[]` | Words never broken at a line end |
| `notes` | `"chapter"` | Note numbers restart with each chapter (`"chapter"`) or run through the book (`"book"`) |
| `end-blanks` | `0` | Pages marked "Page left deliberately blank" before the back cover |
| `figure-dpi` | `300` | Resolution at which figure images are sized |

## Templates

The three designs offered for the Kuki book. `vbook samples` builds a book in each and sets matching pages side by side in `build/samples.png`, with the full PDFs in `build/samples/`. Each sample uses its template's own page and fonts, whatever `book.toml` overrides.

| Template | Kuki sample | Design | Page and margins | Text stack |
|---|---|---|---|---|
| `classic` | A, Classic scholarly (chosen for Kuki) | EB Garamond; centred small-capital headings; source pages in the outer margin; 28% note rule | 156 × 234 mm; inside 22, outside 26, top 22, bottom 24 mm | EB Garamond 12, Gentium Book Plus, Hiragino Mincho ProN, Noto Serif JP, STIX Two Text, STIX Two Math, Apple Symbols |
| `modern` | B, Modern academic | Source Serif 4 text; Source Sans 3 semibold headings in navy, left-aligned; source pages inline as small grey `[N]`; full-width navy note rule | 156 × 234 mm; inside 22, outside 24, top 20, bottom 22 mm | Source Serif 4, Gentium Book Plus, Hiragino Mincho ProN, Noto Serif JP, STIX Two Text, STIX Two Math, Apple Symbols |
| `kintsugi` | C, Kintsugi | Crimson Pro and Shippori Mincho; centred gold headings; section numbers as kanji (一, 二, …); gold hairline under the running head and above the notes; figures between gold rules; source pages in gold in the margin | as `modern` | Crimson Pro, Gentium Book Plus, Shippori Mincho, Noto Serif JP, STIX Two Text, STIX Two Math, Apple Symbols |

All three set 10.5 pt body type; the mono stack is Menlo, DejaVu Sans Mono and the template's Mincho. Kintsugi turns a section heading that begins with a number and a full stop (`## 3. The Three Modes`) into its kanji numeral.

Fonts not on the system are open fonts available from Google Fonts or as Homebrew casks (`font-source-serif-4`, `font-source-sans-3`, `font-crimson-pro`, `font-shippori-mincho`). Typst sets the variable Source Serif 4 at its default optical size (20 pt); its text is a little more open than the 10.5 pt optical size a browser would choose.

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
| `handover` | `"partial"` | `"partial"` or `"final"`, for the header of returns (docs/handover.md) |
| `bibliography` | none | A bibliography file for Pandoc's citeproc |
| `csl` | none | A CSL style for it |

## [markers]

| Key | Default | |
|---|---|---|
| `page` | `'\[p\. (\d+)\]'` | Regular expression for a source page marker; group 1 is the number set in the margin |
| `strip` | `[]` | Regular expressions removed from the book, e.g. `'\[コマ [^\]]*\]'` for image numbers |

Use TOML's single-quoted strings for regular expressions, so that backslashes are kept.

## [imprint]

The imprint page, on the back of the title page. The head of the page reads, from the top: the logo, the series name (in upper and lower case, roman or italic, or in tracked capitals, by `series-style`; with its number, if set, in lining figures), the publisher in tracked capitals, then place and web address. `credits` from `[book]` and the fields below stand at the foot, in this order. Every field is optional and a missing one leaves no gap. In a series, the publisher's side writes this table.

| Key | |
|---|---|
| `publisher`, `publisher-place`, `publisher-url` | The publisher (e.g. Vector Humanities), under the series name |
| `publisher-logo` | `{ image = "…", width = "14mm" }` |
| `series`, `series-number` | Series name, above the publisher, and the book's number in the series |
| `series-style` | `"roman"` (default), `"italic"` or `"caps"`: how the series name is set |
| `edition` | *Markdown.* "First published 2026", "Preliminary edition, 2026" |
| `copyright` | List of *Markdown* lines: "Translation © … 2026", "Original text: public domain" |
| `moral-rights` | *Markdown.* The assertion of the author's or translator's right to be identified |
| `licence` | *Markdown.* E.g. `"This work is licensed under a [Creative Commons Attribution 4.0 International Licence](https://creativecommons.org/licenses/by/4.0/) (CC BY 4.0)."` |
| `third-party` | *Markdown.* Material outside the licence, and its credits |
| `ai` | *Markdown.* AI disclosure |
| `catalogue` | List of *Markdown* lines: British Library and Library of Congress cataloguing statements, as the libraries supply them |
| `isbn` | One ISBN as a string, or one per format: `{ pdf = "…", paperback = "…" }`. On the back cover below the panel: the print ISBN if there is one, otherwise the first |
| `doi` | Printed as a link, e.g. `"10.5281/zenodo.1234567"` |
| `typeset` | Default: a line Vector Book writes from the fonts this book's characters reach ("Typeset in EB Garamond 12, Gentium Book Plus and Hiragino Mincho ProN with Vector Book."). A string replaces it; `false` leaves it out |
| `other` | *Markdown.* Cover design, printer, anything else |

Identifiers come last: `isbn` and `doi` are added when the book is published, and the book is rebuilt.

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
| `quote-source` | *Markdown.* Set in tracked capitals; emphasis in it (a title) is set in small capitals |
| `blurb` | *Markdown, paragraphs* |

## Fonts folder

A `fonts/` folder in the book folder is passed to Typst with `--font-path`, so a book can carry its own open fonts.
