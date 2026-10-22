// Organic: a striking design in the manner of contemporary theory paperbacks.
// 130 × 190 mm; Fira Sans Condensed text; chapter titles in huge stacked Archivo capitals, broken across
// lines; a generated field page (black, colour and stipple, drawn from the book) before every chapter;
// a huge Contents.
#import "../lib/base.typ": *

#let ink = rgb("#0d0d0d")
#let display = ("Archivo", "Fira Sans")
#let sans = ("Fira Sans", "Hiragino Kaku Gothic ProN")

#let style = base-style + (
  stretch: 75%,
  leading: 0.58em, spacing: 0.58em, indent: 1em,
  head-font: sans, head-colour: ink,
  h1: (size: 38pt, weight: "regular", tracking: -0.01em, case: "upper", align: left, font: display,
       leading: 0.12em, hyphenate: true),
  h2: (size: 11pt, weight: "bold", case: "none", align: left),
  h3: (size: 1em, weight: "semibold", style: "italic", align: left),
  num: (size: 8pt, tracking: 0.14em, case: "upper", fill: ink, weight: "bold", font: sans),
  orig: (size: 12pt, fill: luma(70)),
  chapter-sink: 2mm, chapter-gap: 11mm,
  runhead: (size: 6.8pt, tracking: 0.12em, case: "upper", fill: ink, rule: none, weight: "bold", font: sans),
  folio: (size: 8pt, fill: ink),
  marker: "margin", marker-fill: luma(120), marker-font: sans,
  note-size: 7.6pt, note-rule: line(length: 100%, stroke: 0.7pt + ink),
  toc: (size: 12.5pt, weight: "bold", leaders: false, gap: 0.62em),
  interludes: "always",
)

#let t = template(style)
#let book = t.book
#let chapter = t.chapter
#let credits-page = t.credits-page
#let frontispiece = t.frontispiece
#let contents = t.contents

// Title page: names at the head, the title stacked as large as the page allows, subtitle at the foot
#let title-page(meta) = { pagebreak(to: "odd", weak: true); plain-page[
  #set par(justify: false, first-line-indent: 0em)
  #set text(fill: ink)
  #if meta.author != none { text(9pt, weight: "bold", font: sans, stretch: 75%, meta.author) }
  #v(8mm)
  #block({
    set par(leading: 0.1em)
    set text(hyphenate: true)
    text(46pt, font: display, tracking: -0.015em, upper(meta.title))
  })
  #v(1fr)
  #set text(font: sans, stretch: 75%)
  #if meta.subtitle != none { text(11pt, weight: "medium", meta.subtitle); v(2mm) }
  #if meta.original-title != none { text(11pt, meta.original-title); v(2mm) }
  #if meta.credit != none { v(4mm); text(8.5pt, weight: "bold", meta.credit) }
] }
