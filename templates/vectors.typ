// Vectors: a design drawn from vector spaces. 140 × 216 mm; IBM Plex Serif text, Space Grotesk headings,
// IBM Plex Mono for labels, running heads and source pages; before every chapter a generated page of
// vector-space imagery (streamlines, arrow fields, tensor glyphs, warped grids, point clouds with basis vectors).
#import "../lib/base.typ": *

#let ink = rgb("#141518")
#let accent = rgb("#1a1aff")
#let display = ("Bricolage Grotesque 96pt", "Space Grotesk")
#let mono = ("IBM Plex Mono", "Menlo")

#let style = base-style + (
  leading: 0.66em, spacing: 0.66em, indent: 1.1em,
  head-font: display, head-colour: ink,
  h1: (size: 56pt, weight: 800, tracking: -0.02em, case: "none", align: left, leading: 0.08em,
       display: true, font: display),
  h2: (size: 13pt, weight: 700, case: "none", align: left, font: display),
  h3: (size: 1em, weight: "medium", style: "normal", align: left),
  num: (size: 8pt, tracking: 0.08em, case: "upper", fill: accent, weight: "medium", font: mono, prefix: [→ ]),
  orig: (size: 11pt, fill: luma(80)),
  chapter-sink: 2mm, chapter-gap: 12mm,
  band: 100mm, head-height: 76mm, num-gap: 7mm,
  runhead: (size: 6.6pt, tracking: 0.08em, case: "upper", fill: luma(110), rule: none, font: mono),
  folio: (size: 7.5pt, fill: luma(60), font: mono),
  marker: "margin", marker-fill: accent, marker-font: mono,
  note-size: 7.8pt, note-rule: line(length: 30%, stroke: 0.6pt + accent),
  toc: (size: 11pt, weight: "medium", leaders: false, gap: 0.62em),
  interludes: "always",
)

#let t = template(style)
#let book = t.book
#let chapter = t.chapter
#let credits-page = t.credits-page
#let frontispiece = t.frontispiece
#let contents = t.contents

// an arrow drawn in the page's accent: a vector from the origin
#let arrow(len, stroke: 0.8pt + accent) = box(width: len, height: 3mm, {
  place(left + horizon, line(length: len - 1.5mm, stroke: stroke))
  place(right + horizon, polygon(fill: accent, (0mm, -1.2mm), (2.6mm, 0mm), (0mm, 1.2mm)))
})

#let title-page(meta) = { pagebreak(to: "odd", weak: true); plain-page(
  background: place(top, image("/build/fields/title.svg", width: 100%, height: 120mm, fit: "cover")))[
  #set par(justify: false, first-line-indent: 0em, leading: 0.4em)
  #set text(fill: ink)
  #let f = meta.field
  #v(4mm)
  #if meta.author != none { haloed(text(8.5pt, font: mono, tracking: 0.06em, upper(meta.author)), f.ground, f.on-ground); v(5mm) }
  #block(height: 92mm, display-title(meta.title-plain, f.ground, f.on-ground, size: 62pt, font: display))
  #v(6mm)
  #arrow(46mm)
  #if meta.subtitle != none { v(5mm); text(12pt, style: "italic", meta.subtitle) }
  #if meta.original-title != none { v(4mm); text(12pt, meta.original-title) }
  #v(1fr)
  #if meta.credit != none { text(8pt, font: mono, meta.credit) }
] }
