// Frame covers, after the Iwanami title page of 1948 used for the Kuki book:
// a ruled three-column frame with vertical text on the front, a matching frame on the back.
#import "../lib/vbook.typ": *

#let front(meta) = {
  let c = meta.cover
  plain-page(fill: c.paper, margin: (x: 18mm, y: 22mm))[
    #set par(first-line-indent: 0em, justify: false)
    #set text(fill: c.ink)
    #align(center)[
      #v(6mm)
      #if meta.author != none { text(10pt, tracking: 0.32em, upper(meta.author)) }
      #v(5mm)
      #text(22pt, tracking: 0.04em, hyphenate: false, smallcaps(meta.title))
      #v(1fr)
      #if c.frame != none {
        let f = c.frame
        box(stroke: 0.9pt + c.ink, grid(columns: (17mm, 26mm, 17mm), rows: 98mm,
          stroke: (x, y) => if x > 0 { (left: 0.6pt + c.ink) } else { none },
          align(center + horizon, pad(y: 5mm, vcol(f.left, size: 12pt))),
          align(center + horizon, pad(y: 5mm, vcol(f.centre, size: 21pt, weight: "bold"))),
          align(center + top, pad(top: 8mm, vcol(f.right, size: 12pt)))))
      } else if meta.original-title != none {
        text(18pt, tracking: 0.2em, meta.original-title)
      }
      #v(1fr)
      #if meta.credit != none { text(9pt, tracking: 0.05em, meta.credit) }
      #v(4mm)
    ]
  ]
}

#let back(meta) = {
  let c = meta.cover
  let b = meta.back
  pagebreak(to: "even", weak: true)
  plain-page(fill: c.paper, margin: (x: 20mm, y: 24mm))[
    #box(width: 100%, height: 100%, stroke: 0.9pt + c.ink, inset: 9mm)[
      #set par(first-line-indent: 0em, justify: true, leading: 0.62em)
      #set text(fill: c.ink)
      #if b.portrait != none {
        align(center)[
          #box(stroke: 0.5pt + c.ink, image(b.portrait.image, width: b.portrait.width))
          #if b.portrait.caption != none { v(1.5mm); text(7.5pt, tracking: 0.08em, b.portrait.caption) }
        ]
        v(7mm)
      }
      #if b.quote != none {
        align(center, text(10.5pt, style: "italic", b.quote))
        if b.quote-source != none { v(3mm); align(center, text(8.5pt, tracking: 0.08em, b.quote-source)) }
        v(12mm)
      }
      #if b.blurb != none {
        set par(spacing: 0.9em)
        text(9.6pt, b.blurb)
      }
      #v(1fr)
      #align(center)[
        #line(length: 22mm, stroke: 0.5pt + c.accent)
        #v(5mm)
        #if meta.credit != none { text(9pt, tracking: 0.05em, meta.credit) }
        #if meta.affiliation != none { v(1mm); text(8pt, fill: c.ink.lighten(20%), meta.affiliation) }
      ]
    ]
  ]
}
