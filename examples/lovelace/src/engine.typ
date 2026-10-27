// Source for figures/engine.svg: the store, the mill and the two sets of cards, as the memoir describes them.
// typst compile src/engine.typ figures/engine.svg
#set page(width: 120mm, height: 66mm, margin: 0mm, fill: white)
#set text(font: ("EB Garamond 12", "STIX Two Text"), size: 8.5pt)
#let ink = black
#let arrow(from, to, label: none, dx: 0mm, dy: 0mm) = {
  place(top + left, line(start: from, end: to, stroke: 0.6pt + ink))
  let (x0, y0) = from; let (x1, y1) = to
  let a = calc.atan2((x1 - x0) / 1mm, (y1 - y0) / 1mm)
  let h(s) = (x1 - 2.2mm * calc.cos(a + s * 22deg), y1 - 2.2mm * calc.sin(a + s * 22deg))
  place(top + left, polygon(fill: ink, to, h(1), h(-1)))
  if label != none { place(top + left, dx: (x0 + x1) / 2 + dx, dy: (y0 + y1) / 2 + dy, text(7.5pt, style: "italic", label)) }
}
// the store: columns of discs, V0 ... V5
#place(top + left, dx: 4mm, dy: 4mm, text(9pt, smallcaps[Store]))
#for i in range(6) {
  let x = 6mm + i * 9mm
  place(top + left, dx: x, dy: 11mm, rect(width: 6mm, height: 24mm, stroke: 0.5pt + ink))
  for j in range(5) { place(top + left, dx: x + 1.5mm, dy: 13mm + j * 4.4mm, circle(radius: 1.5mm, stroke: 0.35pt + ink)) }
  place(top + left, dx: x + 0.6mm, dy: 36.5mm, $upright(bold(V))_#i$)
}
#place(top + left, dx: 58mm, dy: 22mm, text(9pt)[…])
// the mill
#place(top + left, dx: 82mm, dy: 11mm, rect(width: 32mm, height: 24mm, stroke: 0.8pt + ink,
  align(center + horizon, stack(spacing: 2.4mm, text(9pt, smallcaps[Mill]), text(8pt)[$+ quad - quad times quad div$]))))
#arrow((64mm, 19mm), (81mm, 19mm), label: [numbers], dx: -5mm, dy: -4.2mm)
#arrow((81mm, 28mm), (64mm, 28mm), label: [results], dx: -4mm, dy: 1.2mm)
// the cards
#let deck(x, y, n) = for k in range(n) { place(top + left, dx: x + k * 1.2mm, dy: y - k * 1.2mm,
  rect(width: 18mm, height: 8mm, fill: white, stroke: 0.45pt + ink, {
    for c in range(5) { place(top + left, dx: 2mm + c * 3.2mm, dy: 3mm, circle(radius: 0.6mm, fill: if calc.rem(c + k, 2) == 0 { ink } else { white }, stroke: 0.3pt + ink)) }
  })) }
#deck(22mm, 52mm, 4)
#place(top + left, dx: 19mm, dy: 61.5mm, text(8pt)[Variable-cards])
#deck(89mm, 52mm, 4)
#place(top + left, dx: 86mm, dy: 61.5mm, text(8pt)[Operation-cards])
#arrow((33mm, 47mm), (33mm, 40mm), label: [which columns], dx: 2mm, dy: -1mm)
#arrow((100mm, 47mm), (100mm, 36mm), label: [which operation], dx: 2mm, dy: -1mm)
