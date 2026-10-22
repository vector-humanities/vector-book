# Conventions of the Text {num="Chapter 1" orig="凡例" run="Conventions"}

## Page Markers

[p. 1] [img 7] A marker in square brackets, such as the one that opens this paragraph in the source file, records where a page of the source edition begins. The build sets it as a small number in the outer margin, beside the line where the page begins, so that a reader can find any passage in the original.[^c1-1] A second pattern, here an image number, is removed from the book while it stays in the files for checking against the page images.

Markers may fall anywhere in a paragraph. This sentence is long enough to run on across the measure, and the marker that follows it begins the second page [p. 2] of the notional source, partway through a line of the translation. Notes keep their markers out of the margin: a marker inside a note definition is dropped.

## Notes and Insertions

Every note is the translator's and begins "Tr.". The author's own references stay in the text as printed, for example (Kant, *KrV*, B 106). Where the translator adds words the source does not have, they stand in tortoise-shell brackets: the encounter 〔of two independent series〕 is the core of the contingent.[^c1-2] Nothing the translator adds sits unmarked in the author's sentences.

Notes restart at 1 with each chapter. They sit at the foot of the page in a smaller size, set off by a short rule.

## Languages

The font stack covers Latin with its diacritics (Kuki Shūzō, Gūzensei no mondai, Hegel's *Vermittlung*), Japanese (偶然性の問題), Greek (ποταμοῖς τοῖς αὐτοῖς ἐμβαίνομέν τε καὶ οὐκ ἐμβαίνομεν), and the signs of logic (∀x ∃y, p → q, ¬(p ∧ q)). Each script falls through the stack to the first font that has it. `vbook sweep` sets every distinct character in the book on a test page and reports any that reach a font outside the stack or no font at all.

Some words should never break across a line. The configuration protects them by name: contingency and contingencies are never hyphenated in this book.

[p. 3]

## Verse

Verse goes in a note with its original as printed and a close translation; the text keeps the English.

> The old pond: a frog jumps in, the sound of water.[^c1-3]

Where verse must stand in the text, a line block keeps its lines:

| The old pond,
|     a frog jumps in,
| the sound of water.

## Quotation

> We step and do not step into the same rivers; we are and are not.[^c1-4]

[^c1-1]: Tr. In a translation from page images the marker gives the printed page; the image number goes beside it in the files and is stripped from the book.
[^c1-2]: Tr. Insertions in 〔 〕 follow the Japanese editorial convention for words added by an editor or quoter.
[^c1-3]: Tr. 古池や蛙飛びこむ水の音 (*furuike ya / kawazu tobikomu / mizu no oto*). Matsuo Bashō, 1686.
[^c1-4]: Tr. ποταμοῖς τοῖς αὐτοῖς ἐμβαίνομέν τε καὶ οὐκ ἐμβαίνομεν, εἶμέν τε καὶ οὐκ εἶμεν. Heraclitus, fragment B 49a (Diels-Kranz).
