// Vector Book: functions shared by every template.
// The Lua filter writes calls to these into body.typ; templates style them.

// geometry and running state, set by the template's book() rule
#let vb-geom = state("vb-geom", (width: 156mm, inside: 22mm, outside: 26mm))
#let vb-run = state("vb-run", none)
#let vb-folio = state("vb-folio", false)
#let vb-in-outline = state("vb-in-outline", false)
#let vb-style = state("vb-style", (
  marker-size: 7pt,
  gloss-size: 5.5pt, gloss-fill: rgb("#5a4a2a"), gloss-font: ("EB Garamond 12",),
  key-size: 7.8pt,
  marker: "margin", marker-fill: luma(110), marker-font: none, figure-rule: none,
))

// Pandoc writes these for horizontal rules
#let horizontalRule = v(0.5em)
#let divider() = v(0.5em)

// A caption that shows its long form in the text and its short form in outlines,
// so that notes in a caption do not reach the List of Figures.
#let flex(long, short) = context if vb-in-outline.get() { short } else { long }

// Source page number from a [p. N] marker: in the outer margin, or inline in brackets
#let pm(n) = context {
  let s = vb-style.get()
  let f = if s.marker-font != none { (font: s.marker-font) } else { (:) }
  if s.marker == "inline" {
    return box(text(s.marker-size, fill: s.marker-fill, number-type: "lining", baseline: -1pt, ..f, [\[#n\]]) + h(0.2em))
  }
  let g = vb-geom.get()
  let pos = here().position()
  let recto = calc.odd(pos.page)
  let target = if recto { g.width - g.outside + 3.5mm } else { g.outside - 3.5mm - 8mm }
  // the zero-width box sits on the baseline; raise the number by its height so the baselines align
  let num = text(s.marker-size, fill: s.marker-fill, number-type: "lining", ..f, n)
  box(width: 0pt, place(top + left, dx: target - pos.x, dy: -measure(num).height,
    box(width: 8mm, align(if recto { left } else { right }, num))))
}

// English gloss laid over a figure label
#let gloss(body, ralign: false) = context {
  let s = vb-style.get()
  box(width: 60mm, {
    set par(justify: false, first-line-indent: 0em)
    set text(s.gloss-size, style: "italic", fill: s.gloss-fill, font: s.gloss-font, hyphenate: false)
    if ralign { align(right, body) } else { body }
  })
}

// Key under a figure: label translations, notes on marks
#let figkey(body) = context block(above: 0.3em, below: 1.2em,
  align(left, text(vb-style.get().key-size, fill: luma(60), body)))

// Figure with optional overlays. Overlay positions are fractions of the image's width and height.
// A table in small type with close cells, for raw Typst tables wider than the pipe-table style allows
#let vb-small-table(body) = block(width: 100%, breakable: true, {
  set text(7pt, hyphenate: false)
  set par(justify: false, first-line-indent: 0em, leading: 0.4em)
  set table(inset: (x: 2.5pt, y: 2pt), stroke: 0.3pt + luma(140))
  show figure: set block(breakable: true)
  align(center, body)
})

// A table too wide for the page, set on its own page turned through ninety degrees
#let vb-turned(body) = page(flipped: true, header: none, footer: none, margin: 14mm, {
  set text(6pt, hyphenate: false)
  set par(justify: false, first-line-indent: 0em, leading: 0.35em)
  set table(inset: (x: 1.8pt, y: 1.5pt), stroke: 0.3pt + luma(140))
  show figure: set block(breakable: true)
  align(center + horizon, body)
})

#let vfig(path, width: auto, caption: none, short: none, key: none, overlays: ()) = {
  let img = image(path, width: width)
  let body = context {
    let s = measure(img)
    let rule = vb-style.get().figure-rule
    let framed(b) = if rule == none { b } else { box(stroke: (left: rule, right: rule), inset: (x: 3mm), b) }
    framed(box(width: s.width, height: s.height, {
      img
      for o in overlays {
        let ra = o.at("align", default: "left") == "right"
        place(top + left, dx: o.x * s.width - (if ra { 60mm } else { 0mm }), dy: o.y * s.height,
          gloss(o.en, ralign: ra))
      }
    }))
  }
  let cap = if caption == none { none } else if short == none { caption } else { flex(caption, short) }
  figure(body, caption: cap)
  if key != none { figkey(key) }
}

// A head joined to branches by a brace, as in Kuki's scheme of onozukara, mizukara and jinen
#let schemetag(body) = text(0.88em, fill: luma(80), body)
#let scheme(head, branches) = block(above: 1.1em, below: 1.1em, breakable: false, pad(left: 1.2em, {
  set text(0.92em, hyphenate: false)
  set par(first-line-indent: 0em, justify: false, leading: 0.5em)
  grid(columns: (auto, auto, 1fr), column-gutter: 0.6em, align: horizon,
    head,
    text(4.2em, [{]),
    stack(spacing: 1em, ..branches))
}))

// Vertical CJK column for covers: one cluster per line
#let vcol(t, size: 13pt, weight: "regular") = stack(dir: ttb, spacing: size * 0.18,
  ..t.clusters().map(c => box(width: size * 1.2, height: size * 1.1,
    align(center + horizon, text(size, weight: weight, top-edge: "ascender", bottom-edge: "descender", c)))))

// Section break: the mark centred, with space above and below; the next paragraph starts flush
#let section-break(..args) = {
  let mark = if args.pos().len() > 0 { args.pos().at(0) } else { [\* \* \*] }
  block(above: 1.1em, below: 1.1em, width: 100%, align(center, text(tracking: 0.3em, mark)))
}

// Plain text of a piece of content, for designs that rearrange a title's words
#let to-string(c) = {
  if type(c) == str { c }
  else if c.has("text") { c.text }
  else if c.has("children") { c.children.map(to-string).join() }
  else if c.has("body") { to-string(c.body) }
  else { " " }
}

// Text over imagery: a halo in the ground colour cut out behind the letters, then the letters
#let haloed(body, ground, fill, halo: 3.2pt) = box({
  place(text(fill: ground, stroke: (paint: ground, thickness: halo, join: "round"), body))
  text(fill: fill, body)
})

// A display title over imagery: set straight and large, sized down only as far as its longest word
// needs to fit the measure, with a halo in the ground colour behind every line.
#let display-title(title, ground, fill, size: 60pt, font: ("Bricolage Grotesque 96pt", "Space Grotesk"),
                   weight: 800, leading: 0.08em, tracking: -0.02em, halo: none) = layout(region => {
  let words = title.split(" ").filter(w => w.trim() != "")
  let widest = calc.max(..words.map(w => measure(text(10pt, font: font, weight: weight, tracking: tracking, w)).width / 10pt))
  let sz = calc.min(size, region.width * 0.97 / widest)
  let body = {
    set par(leading: leading, justify: false)
    set text(sz, font: font, weight: weight, tracking: tracking, hyphenate: false)
    title
  }
  let h = if halo == none { calc.max(2.5pt, sz * 0.075) } else { halo }
  block(width: 100%, {
    place(top + left, block(width: 100%, text(fill: ground, stroke: (paint: ground, thickness: h, join: "round"), body)))
    text(fill: fill, body)
  })
})

// A tracked line of capitals on a cover or title page; emphasis in it is set in small capitals, since tracked italic reads poorly beside tracked capitals
#let tracked-line(size, body, tracking: 0.08em) = text(size, tracking: tracking, {
  show emph: it => smallcaps(it.body)
  body
})

// The ISBN for the back cover: the print one if the book has several, set below the panel
#let back-isbn(meta, dy: 12mm) = {
  let isbns = meta.imprint.isbn
  if isbns.len() == 0 { return }
  let pick = isbns.find(((k, v)) => lower(k) in ("paperback", "print", "hardback", "hardcover"))
  let (k, v) = if pick != none { pick } else { isbns.at(0) }
  place(bottom + center, dy: dy, text(7.5pt, tracking: 0.06em, [ISBN #v]))
}

// A page of generated preliminaries: no running head, no folio
#let plain-page(body, ..args) = page(header: none, footer: none, ..args, body)

#let blank-pages(n, note: [Page left deliberately blank]) = {
  for i in range(n) {
    plain-page(align(center + horizon, text(8pt, style: "italic", fill: luma(120), note)))
  }
}
