// Kintsugi: sample C of the Kuki book.
// Crimson Pro and Shippori Mincho, gold headings and hairlines, kanji section numbers, figures between gold rules.
#import "../lib/base.typ": *

#let gold = rgb("#9a7b2f")
#let hair = rgb("#b8963e")

#let style = base-style + (
  leading: 0.68em, spacing: 0.68em,
  head-colour: gold,
  h1: (size: 20pt, weight: "medium", tracking: 0.06em, case: "none", align: center),
  h2: (size: 11.5pt, weight: "medium", tracking: 0.06em, case: "none", align: center),
  h3: (size: 1em, weight: "regular", style: "italic", align: center),
  num: (size: 9pt, tracking: 0.3em, case: "none", fill: gold),
  orig: (size: 11pt, fill: luma(85)),
  section-kanji: true,
  runhead: (size: 7.5pt, tracking: 0.14em, case: "upper", fill: luma(85), rule: 0.3pt + hair),
  folio: (size: 9pt, fill: luma(70)),
  marker: "margin", marker-fill: gold,
  note-size: 8pt, note-rule: line(length: 100%, stroke: 0.4pt + hair),
  figure-rule: 0.8pt + hair,
  title: (author-tracking: 0.25em, size: 24pt, weight: "medium", tracking: 0.06em, case: "none",
          font: none, fill: gold, rule: 0.9pt + hair, credit-fill: luma(100)),
)

#let t = template(style)
#let book = t.book
#let chapter = t.chapter
#let title-page = t.title-page
#let credits-page = t.credits-page
#let frontispiece = t.frontispiece
#let contents = t.contents
