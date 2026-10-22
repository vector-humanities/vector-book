# Practice

How to make a book with Vector Book, from what the first one needed. The first book was the vector translation of Kuki Shūzō's 偶然性の問題 (*The Problem of Contingency*, 1935), typeset in October 2026 from a single Markdown master by a purpose-built Pandoc and Typst script; Vector Book generalises that script. Stage 7 of the Vector Translation method (`vt-book`) sets out what a translation needs from any build; this page is how Vector Book meets it.

## 1. Build from the first chapter

Set up `book.toml` as soon as one chapter is merged, and rebuild after every merge. In the Kuki book the faults below appeared only when the whole text was set, each after some hundreds of pages had been written in a form that produced it. Each would have shown in a one-chapter book.

## 2. Keep the text in section files

One file per section, numbered in reading order, with front matter and appendices in their own folders and the glossary as data (`glossary.csv`). The Kuki master was a single 600 KB file with a working header the build had to cut out by searching for the translator's signature. Working notes now go between `<!-- working -->` markers and are dropped by the build.

## 3. Put the book in the configuration

Title, credits, cover text, colours, portraits, blurb and protected words belong in `book.toml`. The Kuki template had the title, the frame text, the colours, the portrait paths, one figure's name and one scheme's full text written into its code. The template and covers in Vector Book take everything from the configuration, so one design serves any book.

## 4. Offer design samples

The translator chooses the design from two or three samples (a title page, a text page with notes, a figure, a glossary page). For Kuki there were three: Classic scholarly (EB Garamond, page numbers in the margin), Modern academic (Source Serif 4 and Source Sans 3, inline page markers) and Kintsugi (Crimson Pro and Shippori Mincho, gold hairlines, kanji section numbers). The translator chose Classic and asked that chapter names not be set in italic. Classic is the template here; the other two are to follow.

## 5. Fonts and the glyph sweep

- Build the font stack per script: a Latin face, a face with full diacritics and Greek, a CJK face, then faces for logic and other signs.
- Prefer static fonts. The variable Noto Serif JP set Kuki's Japanese in ExtraLight; Hiragino Mincho replaced it.
- Run `vbook sweep` whenever the text gains characters. It sets every distinct non-ASCII character on test pages grouped by Unicode block and reports pages that reach a font outside the stack (`fallback`) or no font (`MISSING`, Apple's LastResort). For Kuki it found four *Book of Changes* hexagram signs with no glyph; Apple Symbols was added to the stack.
- Protect key terms from hyphenation (`no-hyphen`). The Kuki translator asked that "contingency" never break.
- For a portable build, carry open fonts in the book's `fonts/` folder. Hiragino is a macOS system font and cannot be redistributed; an open Mincho is needed for a book built elsewhere.

## 6. Source pages in the margin

Page markers `[p. N]` in the text give every passage a stable reference to the edition translated, for change lists, notes, concordances and readers checking a quotation. The build sets them in the outer margin and drops them from notes. Image numbers kept beside them for checking against the scans are stripped from the book.

## 7. Notes

Every note is the translator's, begins "Tr." and restarts with each chapter (the Kuki book has 473). Labels are unique across the book. Pandoc drops footnotes inside raw Typst, which is how the Kuki build lost the notes in its figure captions; Vector Book writes captions through Pandoc, so their notes survive, and keeps them out of the List of Figures. `vbook check` compares the notes set with the notes defined in the sources after every build.

## 8. Figures

- Crop figures from the library's full-resolution images (for Kuki, the National Diet Library's IIIF service at about 300 ppi), keep the archival crops apart from the book files, and level them gently without removing earlier readers' marks. Record each figure's page, region and marks in a manifest.
- Set figures at their size in the source (`figure-dpi`).
- English glosses go over the labels where there is clear space, and in the caption's key where there is none (one Kuki figure was too dense). Measure overlay positions at the figure's printed size, and join words hyphenated across lines in the gloss file, which once split "contin- gent".
- Credit the image source on the credits page as the library requires.

## 9. Tables

Tables are never wrapped as figures. A non-breaking figure around the Kuki glossary overprinted its last page. Tables break across pages with the header repeated. Pandoc gives a long pipe table equal columns, which crushed the Kuki concordance into narrow columns with tall rows; Vector Book sets widths from the contents.

## 10. Covers and front matter

- The cover may follow the typography of the edition translated. The Kuki cover follows the 1948 Iwanami title page: a ruled three-column frame with the title in vertical type, the publisher's column replaced by 英譯 (English translation). Do not reproduce a publisher's name the edition does not carry.
- Front matter: cover, frontispiece if any, title page with the credit line, credits page, Contents, List of Figures, then the front-matter files (Preface, Translator's Note, the author's preface).
- Look for an author's preface on unnumbered pages before the contents. Kuki's own preface was found at the design stage because the printed contents begin after it.
- Back matter: appendices, the glossary last, blank pages if the page count needs them, back cover with portrait, a quotation and the blurb.

## 11. Check every build

`vbook check` after every build: page count, notes set against notes defined, figures set against figures in the sources, missing glyphs. `vbook proof` makes a contact sheet for a look at the whole book. Log each rebuild that changes the page count in the project's `STATUS.md`.

## 12. Paths

All paths are relative to the book folder; Typst's root is the book folder. The Kuki build began with absolute paths in its template and script and failed when the repository moved.

## Faults met in the Kuki book

| Fault | Cause | In Vector Book |
|---|---|---|
| Glossary's last page overprinted | Tables wrapped as non-breaking figures | Tables never wrapped; they break with repeated headers |
| Notes in figure captions lost | Pandoc drops footnotes inside raw Typst | Captions written by Pandoc; notes kept, and left out of the List of Figures |
| Bold in captions set as italic | Hand-written Markdown-to-Typst conversion | Pandoc converts all text |
| Footnote definitions merged into paragraphs | A marker pattern with `\s?` consumed newlines | Markers matched line by line, with `[ \t]?` |
| "expected content, found boolean" | A parameter named `right` shadowed the alignment | Parameter named `ralign` |
| Right-aligned glosses wrapped | Placed in zero-width boxes | Placed in a 60 mm box ending at `x` |
| Japanese set too light | Variable Noto Serif JP | Static Hiragino Mincho before Noto Serif JP in the stack |
| Hexagram signs missing | No font in the stack had them | Glyph sweep; Apple Symbols added |
| "Figure Figure 1" in the List of Figures | Outline rule printed the supplement | Supplement printed for chapters only |
| Contents entries ran together | Inline outline entries | One block per entry |
| Syllogisms indented | First-line indent in block quotes | No indent in block quotes |
| "contin- gent" in a gloss | Hyphenated line in the gloss file | Hyphen and newline joined |
| Concordance crushed into narrow columns | Equal widths from the dash row | Widths from contents |
| Build failed after the move to the repository | Absolute paths | Paths relative to the book folder |
| Author's preface found late | It stands on an unnumbered page before the contents | Survey every page image before partitioning (Vector Translation, rule 2) |
