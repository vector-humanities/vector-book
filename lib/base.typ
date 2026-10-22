// Vector Book: the page design every template shares, set by a style dictionary.
// A template is base-style with overrides; see templates/classic.typ, modern.typ, kintsugi.typ.
#import "vbook.typ": *

#let base-style = (
  // text
  leading: 0.62em, spacing: 0.62em, indent: 1.2em,
  // headings: case is "smallcaps", "upper" or "none"
  head-font: none, head-colour: luma(0),
  h1: (size: 19pt, weight: "regular", tracking: 0.04em, case: "smallcaps", align: center),
  h2: (size: 11pt, weight: "regular", tracking: 0.06em, case: "smallcaps", align: center),
  h3: (size: 1em, weight: "regular", style: "italic", align: left),
  num: (size: 9pt, tracking: 0.25em, case: "smallcaps", fill: luma(0)),
  orig: (size: 11pt, fill: luma(90)),
  chapter-sink: 22mm, chapter-gap: 9mm,
  // section numbers "1." in level-2 headings as kanji (一, 二, …)
  section-kanji: false,
  // running heads and folios
  runhead: (size: 7.5pt, tracking: 0.12em, case: "smallcaps", fill: luma(0), rule: none),
  folio: (size: 9pt, fill: luma(0)),
  // source page markers: "margin" or "inline"
  marker: "margin", marker-fill: luma(110), marker-font: none,
  // notes
  note-size: 8.2pt, note-rule: line(length: 28%, stroke: 0.4pt),
  // figures: a stroke for hairlines either side, or none
  figure-rule: none,
  // title page
  title: (author-tracking: 0.3em, size: 25pt, weight: "regular", tracking: 0.04em, case: "smallcaps",
          font: none, fill: luma(0), rule: 0.4pt + luma(0), credit-fill: luma(0)),
)

#let cased(case, body) = if case == "smallcaps" { smallcaps(body) } else if case == "upper" { upper(body) } else { body }

#let kanji(n) = {
  let d = ("", "一", "二", "三", "四", "五", "六", "七", "八", "九")
  if n < 10 { d.at(n) } else if n < 20 { "十" + d.at(n - 10) } else { d.at(calc.quo(n, 10)) + "十" + d.at(calc.rem(n, 10)) }
}

#let head-text(st, spec, body) = {
  let f = if st.head-font != none { (font: st.head-font) } else { (:) }
  text(spec.size, weight: spec.weight, tracking: spec.at("tracking", default: 0em), fill: st.head-colour,
    style: spec.at("style", default: "normal"), ..f, cased(spec.at("case", default: "none"), body))
}

#let base-runhead(st, meta) = context {
  let p = here().page()
  let opens = query(heading.where(level: 1)).filter(h => h.location().page() == p)
  if opens.len() > 0 { return }
  let run = vb-run.get()
  if run == none { return }
  let t = if calc.odd(p) { run } else { meta.running-title }
  let r = st.runhead
  let body = align(center, text(r.size, tracking: r.tracking, fill: r.fill,
    if r.case == "smallcaps" { smallcaps(lower(upper(t))) } else { cased(r.case, t) }))
  if r.rule != none { block(width: 100%, stroke: (bottom: r.rule), inset: (bottom: 1.5mm), body) } else { body }
}

#let vb-title-note = state("vb-title-note", none)

#let base-chapter(st, title, num: none, orig: none, run: none, note: none) = {
  pagebreak(to: "odd", weak: true)
  v(st.chapter-sink)
  let al = st.h1.align
  if num != none {
    let n = st.num
    align(al, text(n.size, tracking: n.tracking, fill: n.fill,
      if n.case == "smallcaps" { smallcaps(lower(num)) } else { cased(n.case, num) }))
    v(2mm)
  }
  context if vb-style.get().at("notes-reset", default: true) { counter(footnote).update(0) }
  vb-run.update(if run != none { run } else { title })
  vb-title-note.update(note)
  heading(level: 1, supplement: if num != none { num } else { [] }, title)
  vb-title-note.update(none)
  if orig != none { align(al, text(st.orig.size, fill: st.orig.fill, orig)) }
  v(st.chapter-gap)
}

#let base-book(st, meta, body) = {
  let pg = meta.page
  let fonts = meta.fonts.text
  vb-geom.update((width: pg.width, inside: pg.inside, outside: pg.outside))
  vb-style.update(s => s + (notes-reset: meta.notes-reset, gloss-font: (fonts.at(0), "Gentium Book Plus"), marker: st.marker,
    marker-fill: st.marker-fill, marker-font: st.marker-font, figure-rule: st.figure-rule))

  set document(title: meta.title-plain, author: meta.author-plain)
  set text(font: fonts, size: pg.size, lang: meta.lang, region: meta.region, hyphenate: true, number-type: "old-style")
  set par(justify: true, leading: st.leading, spacing: st.spacing, first-line-indent: (amount: st.indent, all: false))
  show heading: set text(font: fonts, weight: "regular")
  show heading: set par(justify: false)
  show regex(meta.nohyphen): it => box(it)

  set page(width: pg.width, height: pg.height,
    margin: (inside: pg.inside, outside: pg.outside, top: pg.top, bottom: pg.bottom),
    header: base-runhead(st, meta), header-ascent: 40%,
    footer: context { if vb-folio.get() { align(center, text(st.folio.size, fill: st.folio.fill, counter(page).display())) } })

  show heading.where(level: 1): it => block(width: 100%, above: 0pt, below: 4mm,
    align(st.h1.align, head-text(st, st.h1, it.body) + context {
      let n = vb-title-note.get()
      if n != none { footnote(n) }
    }))
  show heading.where(level: 2): it => block(width: 100%, above: 1.4em, below: 0.9em, sticky: true, {
    show regex(if st.section-kanji { "^\d+\.\s+" } else { "\u{E000}\u{E001}" }): m => {
      kanji(int(m.text.trim().trim(".")))
      h(0.8em)
    }
    align(st.h2.align, head-text(st, st.h2, it.body))
  })
  show heading.where(level: 3): it => block(above: 1.1em, below: 0.6em, sticky: true,
    align(st.h3.align, head-text(st, st.h3, it.body)))
  show heading.where(level: 4): it => block(above: 1em, below: 0.5em, sticky: true, text(pg.size, it.body))

  // notes restart with each chapter unless design.notes = "book"
  set footnote.entry(separator: st.note-rule, gap: 0.45em, clearance: 1.1em, indent: 0em)
  show footnote.entry: set text(st.note-size)
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
  // references from Pandoc's citeproc, in a ::: {#refs} block
  show <refs>: set par(first-line-indent: 0em, hanging-indent: 1.5em, justify: false, spacing: 0.7em)

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

#let base-title-page(st, meta) = { pagebreak(to: "odd", weak: true); plain-page[
  #set text(hyphenate: false)
  #let t = st.title
  #let f = if t.font != none { (font: t.font) } else { (:) }
  #v(55mm)
  #set par(justify: false)
  #align(center)[
    #if meta.author != none { text(11pt, tracking: t.author-tracking, upper(meta.author)); v(7mm) }
    #text(t.size, weight: t.weight, tracking: t.tracking, fill: t.fill, hyphenate: false, ..f, cased(t.case, meta.title))
    #if meta.subtitle != none { v(3mm); text(13pt, style: "italic", meta.subtitle) }
    #if meta.original-title != none { v(4mm); text(15pt, tracking: 0.2em, meta.original-title) }
    #v(14mm)
    #line(length: 26mm, stroke: t.rule)
    #v(12mm)
    #if meta.credit != none { text(9pt, tracking: 0.04em, fill: t.credit-fill, meta.credit) }
  ]
] }

#let base-credits-page(meta) = plain-page[
  #v(1fr)
  #set text(8.2pt)
  #set par(first-line-indent: 0em, justify: false, spacing: 1em)
  #meta.credits
  #if meta.licence != none { v(0.4em); meta.licence }
  #if meta.isbn != none or meta.doi != none {
    v(0.4em)
    if meta.isbn != none [ISBN #meta.isbn \ ]
    if meta.doi != none { [DOI ]; link("https://doi.org/" + meta.doi, "https://doi.org/" + meta.doi) }
  }
]

#let base-frontispiece(meta) = if meta.frontispiece != none {
  plain-page[
    #v(1fr)
    #align(center)[
      #box(stroke: 0.5pt + luma(60), image(meta.frontispiece.image, width: meta.frontispiece.width))
      #if meta.frontispiece.caption != none { v(3mm); text(8pt, tracking: 0.1em, meta.frontispiece.caption) }
    ]
    #v(1fr)
  ]
}

#let base-contents(meta) = {
  pagebreak(to: "odd")
  vb-folio.update(true)
  outline(title: [Contents], depth: 1, indent: 1em)
  context if query(figure.where(kind: image)).len() > 0 {
    pagebreak(to: "odd")
    outline(title: [List of Figures], target: figure.where(kind: image))
  }
}

// Bind a style to the functions a template exports.
#let template(st) = (
  book: (meta, body) => base-book(st, meta, body),
  chapter: (title, ..args) => base-chapter(st, title, ..args),
  title-page: meta => base-title-page(st, meta),
  credits-page: base-credits-page,
  frontispiece: base-frontispiece,
  contents: base-contents,
)
