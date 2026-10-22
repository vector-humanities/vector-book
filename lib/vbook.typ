// Vector Book: functions shared by every template.
// The Lua filter writes calls to these into body.typ; templates style them.

// geometry and running state, set by the template's book() rule
#let vb-geom = state("vb-geom", (width: 156mm, inside: 22mm, outside: 26mm))
#let vb-run = state("vb-run", none)
#let vb-folio = state("vb-folio", false)
#let vb-in-outline = state("vb-in-outline", false)
#let vb-style = state("vb-style", (
  marker-size: 7pt, marker-fill: luma(110),
  gloss-size: 5.5pt, gloss-fill: rgb("#5a4a2a"), gloss-font: ("EB Garamond 12",),
  key-size: 7.8pt, chapter-sink: 22mm,
))

// Pandoc writes these for horizontal rules
#let horizontalRule = v(0.5em)
#let divider() = v(0.5em)

// A caption that shows its long form in the text and its short form in outlines,
// so that notes in a caption do not reach the List of Figures.
#let flex(long, short) = context if vb-in-outline.get() { short } else { long }

// Source page number in the outer margin, from a [p. N] marker
#let pm(n) = context {
  let g = vb-geom.get()
  let s = vb-style.get()
  let pos = here().position()
  let recto = calc.odd(pos.page)
  let target = if recto { g.width - g.outside + 3.5mm } else { g.outside - 3.5mm - 8mm }
  box(width: 0pt, place(top + left, dx: target - pos.x, dy: 0.15em,
    box(width: 8mm, align(if recto { left } else { right },
      text(s.marker-size, fill: s.marker-fill, number-type: "lining", n)))))
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
#let vfig(path, width: auto, caption: none, short: none, key: none, overlays: ()) = {
  let img = image(path, width: width)
  let body = context {
    let s = measure(img)
    box(width: s.width, height: s.height, {
      img
      for o in overlays {
        let ra = o.at("align", default: "left") == "right"
        place(top + left, dx: o.x * s.width - (if ra { 60mm } else { 0mm }), dy: o.y * s.height,
          gloss(o.en, ralign: ra))
      }
    })
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

// A page of generated preliminaries: no running head, no folio
#let plain-page(body, ..args) = page(header: none, footer: none, ..args, body)

#let blank-pages(n, note: [Page left deliberately blank]) = {
  for i in range(n) {
    plain-page(align(center + horizon, text(8pt, style: "italic", fill: luma(120), note)))
  }
}
