// Classic: the design of the Kuki book (sample A, "Classic scholarly").
// Royal octavo, EB Garamond, centred small-capital headings, source pages in the outer margin.
#import "../lib/vbook.typ": *

#let defaults = (
  width: 156mm, height: 234mm, inside: 22mm, outside: 26mm, top: 22mm, bottom: 24mm,
  size: 10.5pt,
  text: ("EB Garamond 12", "Gentium Book Plus", "Hiragino Mincho ProN", "Noto Serif JP", "STIX Two Text", "STIX Two Math", "Apple Symbols"),
  mono: ("Menlo", "DejaVu Sans Mono", "Hiragino Mincho ProN"),
)

// running heads: running title on versos, chapter on rectos, none on opening pages
#let runhead(meta) = context {
  let p = here().page()
  let opens = query(heading.where(level: 1)).filter(h => h.location().page() == p)
  if opens.len() > 0 { return }
  let run = vb-run.get()
  if run == none { return }
  let t = if calc.odd(p) { run } else { meta.running-title }
  align(center, text(7.5pt, tracking: 0.12em, smallcaps(lower(upper(t)))))
}

#let chapter(title, num: none, orig: none, run: none) = {
  pagebreak(to: "odd", weak: true)
  v(22mm)
  if num != none { align(center, text(9pt, tracking: 0.25em, smallcaps(lower(num)))); v(2mm) }
  counter(footnote).update(0)
  vb-run.update(if run != none { run } else { title })
  heading(level: 1, supplement: if num != none { num } else { [] }, title)
  if orig != none { align(center, text(11pt, fill: luma(90), orig)) }
  v(9mm)
}

#let book(meta, body) = {
  let pg = meta.page
  let fonts = meta.fonts.text
  vb-geom.update((width: pg.width, inside: pg.inside, outside: pg.outside))
  vb-style.update(s => s + (gloss-font: (fonts.at(0), "Gentium Book Plus")))

  set document(title: meta.title-plain, author: meta.author-plain)
  set text(font: fonts, size: pg.size, lang: meta.lang, region: meta.region, hyphenate: true, number-type: "old-style")
  set par(justify: true, leading: 0.62em, spacing: 0.62em, first-line-indent: (amount: 1.2em, all: false))
  show heading: set text(font: fonts, weight: "regular")
  show regex(meta.nohyphen): it => box(it)

  set page(width: pg.width, height: pg.height,
    margin: (inside: pg.inside, outside: pg.outside, top: pg.top, bottom: pg.bottom),
    header: runhead(meta), header-ascent: 40%,
    footer: context { if vb-folio.get() { align(center, text(9pt, counter(page).display())) } })

  show heading.where(level: 1): it => block(width: 100%, above: 0pt, below: 4mm,
    align(center, text(19pt, tracking: 0.04em, smallcaps(it.body))))
  show heading.where(level: 2): it => block(width: 100%, above: 1.4em, below: 0.9em, sticky: true,
    align(center, text(11pt, tracking: 0.06em, smallcaps(it.body))))
  show heading.where(level: 3): it => block(above: 1.1em, below: 0.6em, sticky: true, text(pg.size, style: "italic", it.body))
  show heading.where(level: 4): it => block(above: 1em, below: 0.5em, sticky: true, text(pg.size, it.body))

  // notes restart with each chapter
  set footnote.entry(separator: line(length: 28%, stroke: 0.4pt), gap: 0.45em, clearance: 1.1em, indent: 0em)
  show footnote.entry: set text(8.2pt)
  show footnote.entry: set par(leading: 0.5em, first-line-indent: 0em)

  // figures do not break; tables do, and are never wrapped as figures (a wrapped table overprinted the Kuki glossary)
  set figure(numbering: none, gap: 0.8em)
  show figure.where(kind: image): set block(breakable: false, above: 1.2em, below: 1.2em)
  show figure.where(kind: table): set block(breakable: true, above: 1em, below: 1em)
  show figure.where(kind: table): it => it.body
  show figure.caption: it => align(left, text(8.4pt, it.body))
  set table(align: left, stroke: (x, y) => if y == 0 { (bottom: 0.5pt) } else { none }, inset: (x: 4pt, y: 2.5pt))
  show table: set text(8.2pt)
  show table.cell: set align(left)
  show table: set par(justify: false, first-line-indent: 0em)

  show quote.where(block: true): it => pad(left: 1.2em, right: 1.2em, {
    set par(first-line-indent: 0em, spacing: 0.55em)
    text(0.92em, it.body)
  })
  show raw: set text(font: meta.fonts.mono, size: 0.82em)
  show list: set par(first-line-indent: 0em)
  set list(indent: 0.6em, body-indent: 0.5em)
  show enum: set par(first-line-indent: 0em)

  // outlines: one block per entry; chapter numbers before titles
  show outline: it => { vb-in-outline.update(true); it; vb-in-outline.update(false) }
  show outline.entry.where(level: 1): it => {
    let isfig = it.element.func() == figure
    let s = it.element.supplement
    let pre = if not isfig and s != none and s != [] and s != [Section] { [#s. ] } else { [] }
    block(above: 0.55em, below: 0.55em, link(it.element.location(),
      [#pre#it.body() #box(width: 1fr, repeat(gap: 0.25em)[.]) #it.page()]))
  }
  body
}

#let title-page(meta) = { pagebreak(to: "odd", weak: true); plain-page[
  #v(55mm)
  #set par(justify: false)
  #align(center)[
    #if meta.author != none { text(11pt, tracking: 0.3em, upper(meta.author)); v(7mm) }
    #text(25pt, tracking: 0.04em, hyphenate: false, smallcaps(meta.title))
    #if meta.subtitle != none { v(3mm); text(13pt, style: "italic", meta.subtitle) }
    #if meta.original-title != none { v(4mm); text(15pt, tracking: 0.2em, meta.original-title) }
    #v(14mm)
    #line(length: 26mm, stroke: 0.4pt)
    #v(12mm)
    #if meta.credit != none { text(9pt, tracking: 0.04em, meta.credit) }
  ]
] }

#let credits-page(meta) = plain-page[
  #v(1fr)
  #set text(8.2pt)
  #set par(first-line-indent: 0em, justify: false, spacing: 1em)
  #meta.credits
]

#let frontispiece(meta) = if meta.frontispiece != none {
  plain-page[
    #v(1fr)
    #align(center)[
      #box(stroke: 0.5pt + luma(60), image(meta.frontispiece.image, width: meta.frontispiece.width))
      #if meta.frontispiece.caption != none { v(3mm); text(8pt, tracking: 0.1em, meta.frontispiece.caption) }
    ]
    #v(1fr)
  ]
}

#let contents(meta) = {
  pagebreak(to: "odd")
  vb-folio.update(true)
  outline(title: [Contents], depth: 1, indent: 1em)
  context if query(figure.where(kind: image)).len() > 0 {
    pagebreak(to: "odd")
    outline(title: [List of Figures], target: figure.where(kind: image))
  }
}
