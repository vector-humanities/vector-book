# Figures, Schemes and Tables {num="Chapter 2" orig="図と表"}

## Figures

[p. 4] A figure is an image on its own line followed by a caption paragraph that begins with its bold number. The image is set at the size it had in the source, from its pixel width and the resolution given in the configuration, and never wider than the text. Glosses from `figures/overlays.json` are laid over its labels in small italic, placed by fractions of the image's width and height. Anything after "Labels:" in the caption is set as a key beneath the figure, and a note in the caption stays in the text without reaching the List of Figures.

![Figure 1](figures/fig-01-encounter.png)

**Figure 1.** Two independent series meeting at a point, drawn for this specimen.[^c2-1] Labels: 甲 A; 乙 B; 邂逅 encounter; 偶然 the contingent.

## Schemes

A scheme joins a head to its branches with a brace. It is written as a fenced block with the class `scheme`: the first paragraph is the head, the list gives the branches, and text in a span with the class `tag` is set small and grey.

::: scheme
Contingency = *the encounter* (*kaikō*)

- [(of two series)]{.tag} hypothetical contingency
- [(of the one and the other)]{.tag} disjunctive contingency
:::

## Tables

[p. 5] Tables are set without a frame, with a rule under the header, and they break across pages with the header repeated. Column widths follow the length of their contents, so that a column of long entries does not crush its neighbours.

| In the section file | In the book | Notes |
|---|---|---|
| `# Title {num="Chapter 1" orig="凡例"}` | Chapter opening on a recto: number, title, original title | `run` gives a shorter running head |
| `[p. 12]` | 12 in the outer margin | Pattern set in `markers.page` |
| `[^c1-2]: Tr. …` | Footnote, numbered from 1 in each chapter | Markers inside notes are dropped |
| `〔 〕` | Set as written | For every word the translator adds to the source |
| `![Figure 1](figures/x.png)` and a `**Figure 1.**` paragraph | Figure at source size with glosses, caption, key | Glosses from `overlays.json` |
| `::: scheme` | Head and branches joined by a brace | Spans `{.tag}` set small |
| A pipe table | Table that breaks across pages | Widths follow content |
| `glossary.csv` | The last chapter, as a table | Columns chosen in `book.toml` |

[^c2-1]: Tr. Figures cropped from page images keep the marks of earlier readers, which are recorded in the figure manifest.
