// Modern: sample B of the Kuki book, "Modern academic".
// Source Serif 4 with Source Sans 3 headings in navy, left-aligned; source pages inline in brackets.
#import "../lib/base.typ": *

#let navy = rgb("#1f3a5f")
#let sans = ("Source Sans 3", "Hiragino Kaku Gothic ProN")

#let style = base-style + (
  leading: 0.68em, spacing: 0.68em,
  head-font: sans, head-colour: navy,
  h1: (size: 20pt, weight: "semibold", tracking: 0.01em, case: "none", align: left),
  h2: (size: 11.5pt, weight: "semibold", tracking: 0.01em, case: "none", align: left),
  h3: (size: 1em, weight: "semibold", style: "normal", align: left),
  num: (size: 9pt, tracking: 0.3em, case: "upper", fill: navy),
  orig: (size: 11pt, fill: luma(85)),
  chapter-sink: 18mm,
  runhead: (size: 7.5pt, tracking: 0.14em, case: "upper", fill: luma(85), rule: none),
  folio: (size: 9pt, fill: luma(70)),
  marker: "inline", marker-fill: luma(135), marker-font: sans,
  note-size: 8pt, note-rule: line(length: 100%, stroke: 0.4pt + navy),
  title: (author-tracking: 0.25em, size: 24pt, weight: "semibold", tracking: 0.01em, case: "none",
          font: sans, fill: navy, rule: 0.4pt + luma(153), credit-fill: luma(100)),
)

#let t = template(style)
#let book = t.book
#let chapter = t.chapter
#let title-page = t.title-page
#let credits-page = t.credits-page
#let frontispiece = t.frontispiece
#let contents = t.contents
