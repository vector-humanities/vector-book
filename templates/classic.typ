// Classic: the design of the Kuki book (sample A, "Classic scholarly").
// Royal octavo, EB Garamond, centred small-capital headings, source pages in the outer margin.
#import "../lib/base.typ": *

#let style = base-style

#let t = template(style)
#let book = t.book
#let chapter = t.chapter
#let title-page = t.title-page
#let credits-page = t.credits-page
#let frontispiece = t.frontispiece
#let contents = t.contents
