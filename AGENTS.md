# Instructions for agents working on this repository

Vector Book typesets books from Markdown section files through Pandoc and Typst. It holds no book: books live in their own repositories and point `vbook` at their folder. Read `README.md`, then `docs/practice.md`, before changing anything.

1. **Keep the template data-driven.** Nothing about a particular book goes into `templates/`, `covers/` or `lib/`. A title, colour, image path or passage of text belongs in the book's `book.toml` or its files.
2. **Test on the specimen and on a real book.** After any change to `lib/`, `templates/`, `covers/` or `vbook`, run `./vbook check examples/specimen` and `./vbook sweep examples/specimen`, and build a real book from a copy, never from its master files. Look at the pages (`./vbook proof`), not only the exit code. Rebuild and commit `examples/specimen/book/specimen.pdf` when its output changes.
3. **Change practice from incidents.** A new rule in `docs/practice.md` names the fault behind it and the book it came from. Update `docs/conventions.md` and `docs/config.md` in the same change as the code, so they agree.
4. **The tool stays light.** `vbook` is standard-library Python 3.11+; the filter is Lua run by Pandoc; the rest is Typst. Install nothing else.
5. **Keep it public-safe.** No translation text that has not been published, no correspondence, email addresses, local paths or third-party copyrighted material. Specimen content is in the public domain or written for the specimen. Scan before every push.
6. **Writing rules** for every file, comments included: no em or en dashes in prose; none of *legible*, *honest*, *load-bearing*, *gestures toward*, *the seam*, *quietly*, *substrate*, "the tension between", "not X but Y", "chosen, not found"; no aphoristic closers, chiasmus or "worse than" comparisons; no sentence assessing the one before; headings as plain noun phrases; British spelling.
7. **Commits** are authored as David M. Berry with the GitHub noreply address, without a co-author trailer.

## Layout

```
vbook                command: new, build, check, sweep, proof, fonts
lib/vbook.lua        Pandoc filter: chapters, figures and overlays, schemes, alignment, table widths, heading shift
lib/vbook.typ        Typst functions the filter calls: margin markers, figures, glosses, schemes, vertical columns
templates/*.typ      page designs; each exports book(), chapter(), title-page(), credits-page(), frontispiece(), contents()
covers/*.typ         covers; each exports front() and back()
starter/             the project vbook new copies
examples/specimen/   a book that uses every convention
docs/                conventions, configuration, practice
brand/               the mark and its generator (brand/src/mark.py)
```

A build copies `lib/`, `templates/` and `covers/` into the book's `build/.vbook/`, so that Typst's root is the book folder. `build/` is generated and ignored.
