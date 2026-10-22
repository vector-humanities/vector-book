// Field covers: a generated field (black, colour and stipple, seeded by the book's title) full bleed,
// with the title stacked over it in huge grotesque capitals; a black back cover with white text.
#import "../lib/vbook.typ": *

#let display = ("Archivo", "Fira Sans")
#let sans = ("Fira Sans", "Hiragino Kaku Gothic ProN")

#let front(meta) = {
  plain-page(margin: (x: 10mm, top: 10mm, bottom: 12mm),
    background: image("/build/fields/cover.svg", width: 100%, height: 100%, fit: "cover"))[
    #set par(justify: false, first-line-indent: 0em)
    #set text(fill: rgb("#0d0d0d"), hyphenate: false, font: sans, stretch: 75%)
    #if meta.author != none { box(fill: white, inset: (x: 2mm, y: 1.4mm), text(9pt, weight: "bold", meta.author)) }
    #v(4mm)
    #block({
      set par(leading: 0.06em)
      set text(hyphenate: true)
      text(58pt, font: display, tracking: -0.02em, upper(meta.title))
    })
    #v(1fr)
    #if meta.subtitle != none {
      box(fill: white, inset: (x: 2mm, y: 1.6mm), text(10pt, weight: "bold", meta.subtitle))
    }
  ]
}

#let back(meta) = {
  let b = meta.back
  pagebreak(to: "even", weak: true)
  plain-page(fill: meta.field.ink, margin: (x: 12mm, top: 14mm, bottom: 22mm))[
    #set par(first-line-indent: 0em, justify: false, leading: 0.5em, spacing: 0.9em)
    #set text(fill: meta.field.on-ink, font: sans, stretch: 75%)
    #if b.quote != none {
      block(text(15pt, weight: "bold", b.quote))
      if b.quote-source != none { v(2mm); text(8.5pt, tracking: 0.08em, upper(b.quote-source)) }
      v(9mm)
    }
    #if b.blurb != none { text(9.6pt, weight: "medium", b.blurb) }
    #v(1fr)
    #if meta.credit != none { text(8.5pt, weight: "bold", meta.credit) }
    #if meta.affiliation != none { linebreak(); text(8pt, meta.affiliation) }
    #back-isbn(meta, dy: 12mm)
  ]
}
