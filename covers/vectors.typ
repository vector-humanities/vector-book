// Vector covers: a generated page of vector-space imagery full bleed, the title set in the zone kept clear
// for it, in the colour that reads on the palette's ground; the back on the ground with a band of imagery.
#import "../lib/vbook.typ": *

#let display = ("Bricolage Grotesque 96pt", "Space Grotesk")
#let display-weight = 800
#let mono = ("IBM Plex Mono", "Menlo")

// The title set straight and large over the imagery (display-title, in lib/vbook.typ).
#let front(meta) = {
  let f = meta.field
  plain-page(margin: (x: 11mm, top: 13mm, bottom: 13mm),
    background: image("/build/fields/cover.svg", width: 100%, height: 100%, fit: "cover"))[
    #set par(justify: false, first-line-indent: 0em, leading: 0.4em)
    #set text(hyphenate: false)
    #if meta.author != none { haloed(text(9pt, font: mono, tracking: 0.08em, upper(meta.author)), f.ground, f.on-ground) }
    #v(7mm)
    #display-title(meta.title-plain, f.ground, f.on-ground, size: 74pt, font: display, weight: display-weight)
    #v(1fr)
    #if meta.subtitle != none { block(fill: f.ground, inset: (x: 2mm, y: 1.6mm), text(10pt, fill: f.on-ground, meta.subtitle)) }
    #if meta.credit != none { v(2mm); block(fill: f.ground, inset: (x: 2mm, y: 1.4mm), text(7.5pt, font: mono, fill: f.on-ground, meta.credit)) }
  ]
}

#let back(meta) = {
  let b = meta.back
  let f = meta.field
  pagebreak(to: "even", weak: true)
  plain-page(fill: f.ground, margin: (x: 14mm, top: 0mm, bottom: 24mm))[
    #set par(first-line-indent: 0em, justify: false, leading: 0.6em, spacing: 0.9em)
    #set text(fill: f.on-ground)
    #box(width: 100% + 28mm, height: 62mm, clip: true, inset: 0pt, outset: (x: 14mm),
      image("/build/fields/back.svg", width: 100% + 28mm, height: 62mm, fit: "cover"))
    #v(10mm)
    #if b.quote != none {
      block(text(13pt, font: display, weight: "medium", b.quote))
      if b.quote-source != none { v(2mm); text(7.5pt, font: mono, tracking: 0.06em, upper(b.quote-source)) }
      v(8mm)
    }
    #if b.blurb != none { text(9.4pt, b.blurb) }
    #v(1fr)
    #if meta.credit != none { text(7.5pt, font: mono, meta.credit) }
    #if meta.affiliation != none { linebreak(); text(7.5pt, font: mono, meta.affiliation) }
    #back-isbn(meta, dy: 14mm)
  ]
}
