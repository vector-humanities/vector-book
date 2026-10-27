# Conventions

What Vector Book reads in the Markdown section files, and what it makes of it. The specimen in `examples/specimen/` uses each of these; read its files beside `book/specimen.pdf`.

The files are Pandoc Markdown with footnotes, pipe tables, fenced divs, bracketed spans and raw Typst enabled.

## Files

A book is a folder with `book.toml` and the section files it names (see [config.md](config.md)). Files are joined in filename order within each group, front matter first, then body, then back matter; number them `00-`, `01-`, and so on. Image paths are written relative to the book folder.

Text between `<!-- working -->` and `<!-- /working -->` is dropped before the build, as in `vt_assemble.py` of Vector Translation. Editor's notes, queries and working headers can stay in the section files.

## Chapters

A level-one heading opens a chapter: a new recto, sunk 22 mm, the title in small capitals, notes numbered from 1.

```markdown
# Categorical Contingency {num="Chapter 1" orig="定言的偶然" run="Categorical Contingency"}
```

| Attribute | Effect |
|---|---|
| `num` | Printed above the title in spaced small capitals, and before the title in the Contents |
| `orig` | The title in the source language, beneath the title |
| `run` | Running head on rectos, when the title is too long |

A note on the title (`# Title[^c1-ed] {…}`) is set after the title on the opening page, numbered first in the chapter, and kept out of the Contents and the running heads. A section file without a level-one heading continues the chapter before it.

With `parse-headings = true` in `book.toml`, a heading written as `Chapter 1. Categorical Contingency (第一章 定言的偶然)` is read the same way: a leading word and number become `num`, and a final parenthesis containing Chinese, Japanese or Korean characters becomes `orig`. Use this for a master file written before the attributes existed.

In `classic`, level-two headings are centred small capitals, level three is italic and level four is roman; the other templates differ (see [config.md](config.md#templates)). If the files use `##` for chapters, set `shift-headings = -1`; a heading shifted above level one (a document title) is dropped.

Running heads give the running title on versos and the chapter on rectos, and none on a chapter's opening page.

## Page markers

```markdown
[p. 12]
```

marks where page 12 of the source edition begins. It is set as a small number in the outer margin, on the baseline of the line where the page begins (`classic`, `kintsugi`), or inline as a small grey `[12]` (`modern`). The pattern is configurable (`markers.page`, a regular expression whose first group is the number). Further patterns in `markers.strip` are removed from the book and kept in the files: in a translation from page images, the image number beside each page marker.

A marker standing alone as a paragraph, such as `[p. 311]` on the line before a chapter heading, joins the next paragraph, so that its number is set beside the first line of the new page and not on the page before the chapter opens. Markers inside a footnote definition are dropped, so that notes do not put numbers in the margin. Markers inside code spans and code blocks are left alone.

## Notes

Pandoc footnotes, `[^label]` in the text and `[^label]: …` on a line of its own. In a translation every note is the translator's and begins "Tr."; the author's own references stay in the text as printed. Numbers restart with each chapter unless `design.notes = "book"`. Labels must be unique across the whole book: prefix them by section (`[^c3s8-4]` for chapter 3, section 8, note 4).

## Insertions

Words the translator adds to the author's sentence go in tortoise-shell brackets, 〔 〕, the Japanese editorial convention for words added by an editor or quoter. They are set as written.

## Verse

Verse that must keep its lines is written as a line block:

```markdown
| The old pond,
|     a frog jumps in,
| the sound of water.
```

In a translation the convention is to keep the English in the text and give the original as printed, with a close translation, in a note.

## Figures

An image on a line of its own, followed by a caption paragraph that begins with the figure's number in bold:

```markdown
![Figure 1](figures/fig-01-encounter.png)

**Figure 1.** Two independent series meeting at a point (1948, p. 77). Labels: 甲 A; 乙 B; 邂逅 encounter.
```

A caption written as the image's alt text also works. The figure is built as follows.

- **Size.** A PNG or JPEG is set at the size it had in the source: its pixel width divided by `figure-dpi` (300 by default), never wider than the text. Give `{width=60mm}` after the image to set it directly; an SVG without a width is set at 70% of the measure.
- **Caption and key.** Text from "Labels:" or "Key:" onwards is set as a key in small grey type under the figure. The rest is the caption, and is set in full in the List of Figures, so mark the key of any long caption. `vbook check` lists captions over 20 words with no marker.
- **Notes in captions** are set in the text and left out of the List of Figures.
- **Overlays.** English glosses from `figures/overlays.json` are laid over the figure's labels in 5.5 pt italic. The file maps each image's file name to a list of glosses:

  ```json
  { "fig-01-encounter.png": [ {"x": 0.43, "y": 0.68, "en": "encounter"},
                              {"x": 0.92, "y": 0.10, "en": "the contin-\ngent", "align": "right"} ] }
  ```

  `x` and `y` are fractions of the image's width and height (the top left of the gloss). `align: "right"` sets the gloss to end at `x`. A newline breaks the line; a hyphen before a newline joins the word. To leave a dense figure without overlays, write `{overlays="no"}` after its image and give the English in the key.

Figures do not break across pages. A List of Figures follows the Contents when the book has any.

## Schemes

A head joined to its branches by a brace:

```markdown
::: scheme
Contingency = *the encounter*

- [(of two series)]{.tag} hypothetical contingency
- [(of the one and the other)]{.tag} disjunctive contingency
:::
```

The first paragraph is the head, the list items are the branches, and a span with the class `tag` is set small and grey. Use `\` at the end of a line for a line break inside the head or a branch.

## Section breaks

A paragraph of asterisks or dots alone (`* * *`, `· · ·`, `⁂`) is a section break: the mark is set centred and spaced, with space above and below, and the next paragraph starts without an indent. `::: break` with an empty body sets the template's mark, three spaced asterisks. A horizontal rule (`---`) is set only as a small space.

## Alignment

`::: right` and `::: centre` (or `::: center`) set their contents flush right or centred: a signature under a note, a dedication.

## Tables

Pipe tables. They are set without a frame, with a rule under the header, in 8.2 pt, and they break across pages with the header repeated. Column widths follow the length of the longest cell in each column (Chinese, Japanese and Korean characters count double), unless the table is narrow enough to set at its natural widths or the source gives unequal widths in its dash row.

## Tables too wide for the page

A table with more columns than the measure holds can be written as raw Typst and wrapped in one of two functions from `lib/vbook.typ`: `#vb-small-table[...]` sets it in 7 pt with close cells across the text width, breaking across pages; `#vb-turned[...]` sets it on a page of its own turned through ninety degrees, in 6 pt, without running head or folio. Pandoc writes a Typst table from HTML with its row and column spans (`pandoc -f html -t typst`); the Lovelace sample sets nineteen tables from the 1843 printing this way, the diagrams of Notes D and G on turned pages. A footnote in a cell is written `#footnote[...]` and is numbered with the chapter's other notes.

## Citations and bibliography

With `bibliography` set in `book.toml` (BibTeX, BibLaTeX, CSL JSON or YAML), Pandoc citations are formatted by citeproc: `[@babbage1864, 136]` gives (Babbage 1864, 136), `@fuegi2003` gives Fuegi and Francis (2003), and `[-@key]` drops the name. Citations work in the text, in footnotes, in captions and in notes on chapter titles. The style is Chicago author-date unless `csl` names another. The list of works cited is set where a file holds

```markdown
# Bibliography

::: {#refs}
:::
```

with a hanging indent; put that file in `back/`.

## Glossary

`glossary.csv` (the Vector Translation format: `source,reading,english,competitors,scope,decided,notes`) is set as the last chapter. `book.toml` chooses the columns and their headings.

## Raw Typst

Anything Pandoc's Markdown cannot say can be written as raw Typst, inline as `` `#text(8pt)[small]`{=typst} `` or as a block fenced with ```` ```{=typst} ````. Functions from `lib/vbook.typ` and the template are available.
