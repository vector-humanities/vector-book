# Preface

Vector Book typesets the editions and translations of Vector Humanities. It takes a folder of Markdown files, one per section, and a short description of the book in `book.toml`, and produces a print-ready PDF through Pandoc and Typst. The design is the one made for the vector translation of Kuki Shūzō's 偶然性の問題 (*The Problem of Contingency*, 1935): Royal octavo, EB Garamond, centred small-capital headings, and the pages of the source edition in the outer margin.

The tool collects what that book needed. Every convention in this specimen answers to a problem met in building it: tables that could not break across pages and overprinted the glossary, notes in figure captions that were lost in conversion, characters missing from the font stack, a key term split by hyphenation at the end of a line. Each is now handled by the build rather than by hand.

This specimen is built from the files in `examples/specimen/`. Read them beside the pages they make.

<!-- working -->
Lines between the working markers stay in the section files and never reach the book. Use them for editor's notes and queries.
<!-- /working -->
