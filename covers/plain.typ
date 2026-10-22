// Plain covers: title, author and credit on paper, no frame. For editions without a source title page to follow.
#import "../lib/vbook.typ": *

#let front(meta) = {
  let c = meta.cover
  plain-page(fill: c.paper, margin: (x: 20mm, y: 26mm))[
    #set par(first-line-indent: 0em, justify: false)
    #set text(fill: c.ink, hyphenate: false)
    #align(center)[
      #v(30mm)
      #if meta.author != none { text(10pt, tracking: 0.32em, upper(meta.author)); v(8mm) }
      #text(26pt, tracking: 0.04em, hyphenate: false, smallcaps(meta.title))
      #if meta.subtitle != none { v(4mm); text(13pt, style: "italic", meta.subtitle) }
      #if meta.original-title != none { v(6mm); text(16pt, tracking: 0.2em, meta.original-title) }
      #v(10mm)
      #line(length: 30mm, stroke: 0.6pt + c.accent)
      #v(1fr)
      #if meta.credit != none { text(9pt, tracking: 0.05em, meta.credit) }
    ]
  ]
}

#let back(meta) = {
  let c = meta.cover
  let b = meta.back
  pagebreak(to: "even", weak: true)
  plain-page(fill: c.paper, margin: (x: 24mm, y: 28mm))[
    #set par(first-line-indent: 0em, justify: true, leading: 0.62em, spacing: 0.9em)
    #set text(fill: c.ink)
    #if b.quote != none {
      align(center, text(10.5pt, style: "italic", b.quote))
      if b.quote-source != none { v(3mm); align(center, tracked-line(8.5pt, b.quote-source)) }
      v(12mm)
    }
    #if b.blurb != none { text(9.6pt, b.blurb) }
    #v(1fr)
    #align(center)[
      #if meta.credit != none { text(9pt, tracking: 0.05em, meta.credit) }
      #if meta.affiliation != none { v(1mm); text(8pt, meta.affiliation) }
    ]
    #back-isbn(meta, dy: 14mm)
  ]
}
