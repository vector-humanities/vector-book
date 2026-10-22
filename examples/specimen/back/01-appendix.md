# Building a Book {num="Appendix A"}

## The Files

A book is a folder. `book.toml` describes it; `front/`, `text/` and `back/` hold the section files, joined in filename order; `figures/` holds the images and `overlays.json`; `glossary.csv` is the glossary, set as the book's last chapter. The book is written to the path given as `output`.

## The Build

`vbook build` assembles the section files, turns page markers into margin numbers, and passes the result through Pandoc with the Vector Book filter, which writes chapters, figures, schemes and table widths as Typst. Typst then sets the book with the chosen template and covers. Run `vbook check` after each build: it compares the notes and figures set with those in the sources and reports missing glyphs.

## Before the First Chapter

Build the book from the first merged chapter and rebuild after every merge. Tables that cannot break, notes lost from captions, and missing characters all show in a one-chapter book.
