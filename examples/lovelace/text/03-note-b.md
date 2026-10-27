# Note B {orig="Notes by the Translator"}

::: right
*To page 676.*
:::

That portion of the Analytical Engine here alluded to is called the storehouse. It contains an indefinite number of the columns of discs described by M. Menabrea. The reader may picture to himself a pile of rather large draughtsmen heaped perpendicularly one above another to a considerable height, each counter having the digits from 0 to 9 inscribed on its *edge* at equal intervals; and if he then conceives that the counters do not actually lie one upon another so as to be in contact, but are fixed at small intervals of vertical distance on a common axis which passes perpendicularly through their centres, and around which each disc can *revolve horizontally* so that any required digit amongst those inscribed on its margin can be brought into view, he will have a good idea of one of these columns. The *lowest* of the discs on any column belongs to the units, the next above to the tens, the next above this to the hundreds, and so on. Thus, if we wished to inscribe 1345 on a column of the engine, it would stand thus:—

1\
3\
4\
5

In the Difference Engine there are seven of these columns placed side by side in a row, and the working mechanism extends behind them; the general form of the whole mass of machinery is that of a quadrangular prism (more or less approaching to the cube); the results always appearing on that perpendicular face of the engine which contains the columns of discs, opposite to which face a spectator may place himself. In the Analytical Engine there would be many more of these columns, probably at least two hundred. The precise form and arrangement [p. 702]which the whole mass of its mechanism will assume is not yet finally determined.

We may conveniently represent the columns of discs on paper in a diagram like the following:—

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: 5,
    align: (auto,auto,auto,auto,auto,),
    [$upright(bold(V))_1$], [$upright(bold(V))_2$], [$upright(bold(V))_3$], [$upright(bold(V))_4$], [&c.],
    [◯], [◯], [◯], [◯], [&c.],
    [0], [0], [0], [0], [],
    [0], [0], [0], [0], table.cell(rowspan: 2)[&c.],
    [0], [0], [0], [0],
    [0], [0], [0], [0], [],
    [□], [□], [□], [□], [&c.],
  )]
  , kind: table
  )
]
```

The $\mathbf{V}$'s are for the purpose of convenient reference to any column, either in writing or speaking, and are consequently numbered. The reason why the letter $\mathbf{V}$ is chosen for this purpose in preference to any other letter, is because these columns are designated (as the reader will find in proceeding with the Memoir) the *Variables*, and sometimes the *Variable columns*, or the *columns of Variables*. The origin of this appellation is, that the values on the columns are destined to change, that is to *vary*, in every conceivable manner. But it is necessary to guard against the natural misapprehension that the columns are only intended to receive the values of the *variables* in an analytical formula, and not of the *constants*. The columns are called Variables on a ground wholly unconnected with the *analytical* distinction between constants and variables. In order to prevent the possibility of confusion, we have, both in the translation and in the notes, written Variable with a capital letter when we use the word to signify a *column of the engine*, and variable with a small letter when we mean the *variable of a formula*. Similarly, *Variable-cards* signify any cards that belong to a column of the engine.

To return to the explanation of the diagram: each circle at the top is intended to contain the algebraic sign + or −, either of which can be substituted[^l-5] for the other, according as the number represented on the column below is positive or negative. In a similar manner any other purely *symbolical* results of algebraical processes might be made to appear in these circles. In Note A. the practicability of developing *symbolical* with no less ease than *numerical* results has been touched on.

The zeros beneath the *symbolic* circles represent each of them a disc, supposed to have the digit 0 presented in front. Only four tiers of zeros have been figured in the diagram, but these may be considered as representing thirty or forty, or any number of tiers of discs that may be required. Since each disc can present any digit, and each circle any sign, the discs of every column may be so adjusted[^l-6] as to express any positive or negative number whatever within the limits of the machine; which limits depend on the *perpendicular* extent of the mechanism, that is, on the number of discs to a column.

[p. 703]Each of the squares below the zeros is intended for the inscription of any *general* symbol or combination of symbols we please; it being understood that the number represented on the column immediately above, is the numerical value of that symbol, or combination of symbols. Let us, for instance, represent the three quantities $a$, $n$, $x$, and let us further suppose that $a = 5$, $n = 7$, $x = 98$. We should have—

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: (auto, auto, auto, auto, auto, ),
    align: (auto,auto,auto,auto,auto,),
    [$upright(bold(V))_1$], [$upright(bold(V))_2$], [$upright(bold(V))_3$], [$upright(bold(V))_4$], [&c.],
    [+#footnote[It is convenient to omit the circles whenever the signs + or − can be actually represented.]], [+], [+], [+], [],
    [0], [0], [0], [0], [],
    [0], [0], [0], [0], [&c.],
    [0], [0], [9], [0], [],
    [5], [7], [8], [0], [&c.],
    [$a$], [$n$], [$x$], [ ], [],
  )]
  , kind: table
  )
]
```

We may now combine these symbols in a variety of ways, so as to form any required function or functions of them, and we may then inscribe each such function below brackets, every bracket uniting together those quantities (and those only) which enter into the function inscribed below it. We must also, when we have decided on the particular function whose numerical value we desire to calculate, assign another column to the right-hand for receiving the *results*, and must inscribe the function in the square below this column. In the above instance we might have any one of the following functions:—

$ax^{n},\qquad x^{an},\qquad a \cdot n \cdot x,\qquad\frac{a}{n}x,\qquad a + n + x,$ &c. &c.

Let us select the first. It would stand as follows, previous to calculation:—

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: (auto, auto, auto, auto, auto, ),
    align: (auto,auto,auto,auto,auto,),
    [$upright(bold(V))_1$], [$upright(bold(V))_2$], [$upright(bold(V))_3$], [$upright(bold(V))_4$], [&c.],
    [+], [+], [+], [+], [],
    [0], [0], [0], [0], [&c.],
    [0], [0], [9], [0], [],
    [5], [7], [8], [0], [&c.],
    [$a$], [$n$], [$x$], [$a x^n$], [&c.],
    table.cell(colspan: 3)[$underbrace(quad quad quad quad quad)$], [], [],
    table.cell(colspan: 3)[$a x_n$], [], [],
  )]
  , kind: table
  )
]
```

The data being given, we must now put into the engine the cards proper for directing the operations in the case of the particular function chosen. These operations would in this instance be,—

Firstly, six multiplications in order to get $x^{n}$ ($= 98^{7}$ for the above particular data).

Secondly, one multiplication in order then to get $a \cdot x^{n}$ ($= 5.98^{7}$).

In all, seven multiplications to complete the whole process. We may thus represent them:—

(×, ×, ×, ×, ×, ×, ×), or 7(×).

The multiplications would, however, at successive stages in the solution of the problem, operate on pairs of numbers, derived from *different* columns. In other words, the *same operation* would be performed [p. 704]on different *subjects of operation*. And here again is an illustration of the remarks made in the preceding Note on the independent manner in which the engine directs its *operations*. In determining the value of $ax^{n}$, the *operations* are *homogeneous*, but are distributed amongst different *subjects of operation*, at successive stages of the computation. It is by means of certain punched cards, belonging to the Variables themselves, that the action of the operations is so *distributed* as to suit each particular function. The *Operation-cards* merely determine the succession of operations in a general manner. They in fact throw all that portion of the mechanism included in the *mill*, into a series of different *states*, which we may call the *adding state*, or the *multiplying state*, &c. respectively. In each of these states the mechanism is ready to act in the way peculiar to that state, on any pair of numbers which may be permitted to come within its sphere of action. Only *one* of these operating states of the mill can exist at a time; and the nature of the mechanism is also such that only *one pair of numbers* can be received and acted on at a time. Now, in order to secure that the mill shall receive a constant supply of the proper pairs of numbers in succession, and that it shall also rightly locate the result of an operation performed upon any pair, each Variable has cards of its own belonging to it. It has, first, a class of cards whose business it is to *allow* the number on the Variable to pass into the mill, there to be operated upon. These cards may be called the *Supplying-cards*. *They* furnish the mill with its proper food. Each Variable has, secondly, another class of cards, whose office it is to allow the Variable to *receive* a number *from* the mill. These cards may be called the *Receiving-cards*. *They* regulate the location of results, whether temporary or ultimate results. The Variable-cards in general (including both the preceding classes) might, it appears to us, be even more appropriately designated the Distributive-cards, since it is through their means that the action of the operations, and the results of this action, are rightly *distributed*.

There are *two varieties* of the *Supplying* Variable-cards, respectively adapted for fulfilling two distinct subsidiary purposes: but as these modifications do not bear upon the present subject, we shall notice them in another place.

In the above case of $ax^{n}$, the Operation-cards merely order seven multiplications, that is, they order the mill to be in the *multiplying state* seven successive times (without any reference to the particular columns whose numbers are to be acted upon). The proper Distributive Variable-cards step in at each successive multiplication, and cause the distributions requisite for the particular case.

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: 3,
    align: (auto,auto,right,),
    [For $x^(a n)$], [the operations would be], table.cell(align: right)[34 (×)],
    [ … $a . n . x$], [………], [\(×, ×), or 2 (×)],
    [ … $a / n . x$], [………], table.cell(align: right)[\(÷, ×)],
    [ … $a + n + x$], [………], [\(+, +), or 2 (+)],
  )]
  , kind: table
  )
]
```

The engine might be made to calculate all these in succession. Having completed $ax^{n}$, the function $x^{an}$ might be written under the brackets instead of $ax^{n}$, and a new calculation commenced (the appropriate Operation and Variable-cards for the new function of course coming into play). The results would then appear on $\mathbf{V}_{5}$. So on for any number of different functions of the quantities $a$, $n$, $x$. Each *result* might [p. 705]either permanently remain on its column during the succeeding calculations, so that when all the functions had been computed, their values would simultaneously exist on $\mathbf{V}_{4}$, $\mathbf{V}_{5}$, $\mathbf{V}_{6}$, &c.; or each result might (after being printed off, or used in any specified manner) be effaced, to make way for its successor. The square under $\mathbf{V}_{4}$ ought, for the latter arrangement, to have the functions $ax^{n}$, $x^{an}$, $a\mspace{9mu} n\mspace{9mu} x$, &c. successively inscribed in it.

Let us now suppose that we have *two* expressions whose values have been computed by the engine independently of each other (each having its own group of columns for data and results). Let them be $ax^{n}$, $b.p.y$. They would then stand as follows on the columns:—

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto, ),
    align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,),
    [$upright(bold(V))_1$], [$upright(bold(V))_2$], [$upright(bold(V))_3$], [$upright(bold(V))_4$], [$upright(bold(V))_5$], [$upright(bold(V))_6$], [$upright(bold(V))_7$], [$upright(bold(V))_8$], [$upright(bold(V))_9$],
    [+], [+], [+], [+], [+], [+], [+], [+], [+],
    [0], [0], [0], [0], [0], [0], [0], [0], [0],
    [0], [0], [0], [0], [0], [0], [0], [0], [0],
    [0], [0], [0], [0], [0], [0], [0], [0], [0],
    [0], [0], [0], [0], [0], [0], [0], [0], [0],
    [$a$], [$n$], [$x$], [$a x^n$], [$b$], [$p$], [$y$], [$b p y$], table.cell(rowspan: 2)[$frac(a x^n, b p y)$],
    table.cell(colspan: 3)[$underbrace(quad quad quad quad)$], [], table.cell(colspan: 3)[$underbrace(quad quad quad quad)$], [],
  )]
  , kind: table
  )
]
```

We may now desire to combine together these two *results*, in any manner we please; in which case it would only be necessary to have an additional card or cards, which should order the requisite operations to be performed with the numbers on the two result-columns, $\mathbf{V}_{4}$ and $\mathbf{V}_{8}$, and the *result of these further operations* to appear on a new column, $\mathbf{V}_{9}$. Say that we wish to divide $ax^{n}$ by $b.p.y$. The numerical value of this division would then appear on the column $\mathbf{V}_{9}$, beneath which we have inscribed $\frac{ax^{n}}{bpy}$. The whole series of operations from the beginning would be as follows ($n$ being $= 7$):—

$\left\{ 7( \times ),\mspace{9mu} 2( \times ),\mspace{9mu} \div \right\}$, or $\left\{ 9( \times ),\mspace{9mu} \div \right\}$.

This example is introduced merely to show that we may, if we please, retain separately and permanently any *intermediate* results (like $ax^{n}$, {{nowrap\|$b.p.y$.), which occur in the course of processes having an ulterior and more complicated result as their chief and final object $\left( \text{like~}\frac{ax^{n}}{bpy} \right)$.

Any group of columns may be considered as representing a *general* function, until a *special* one has been implicitly impressed upon them through the introduction into the engine of the Operation and Variable-cards made out for a *particular* function. Thus, in the preceding example, $\mathbf{V}_{1}$, $\mathbf{V}_{2}$, $\mathbf{V}_{3}$, $\mathbf{V}_{5}$, $\mathbf{V}_{6}$, $\mathbf{V}_{7}$ represent the *general* function $\phi(a,n,b,p,x,y)$ until the function $\frac{ax^{n}}{b.p.y}$ has been determined on, and *implicitly* expressed by the placing of the right cards in the engine. The actual working of the mechanism, as regulated by these cards, then *explicitly* developes the value of the function. The inscription of a function under the brackets, and in the square under the result-column, in no way influences the processes or the results, and is merely a memorandum for the observer, to remind him of what is going on. It is the Operation and the Variable-cards only, which in reality determine the function. Indeed it should be distinctly kept in [p. 706]mind that the inscriptions within *any* of the squares, are quite independent of the mechanism or workings of the engine, and are nothing but arbitrary memorandums placed there at pleasure to assist the spectator.

The further we analyse the manner in which such an engine performs its processes and attains its results, the more we perceive how distinctly it places in a true and just light the mutual relations and connexion of the various steps of mathematical analysis, how clearly it separates those things which are in reality distinct and independent, and unites those which are mutually dependent.A. A. L.

[^l-5]: A fuller account of the manner in which the *signs* are regulated, is given in Mons. Menabrea's Memoir, pages 682, 683. He himself expresses doubts (in a note of his own at the bottom of the latter page) as to his having been likely to hit on the precise methods really adopted; his explanation being merely a conjectural one. That it *does* accord precisely with the fact is a remarkable circumstance, and affords a convincing proof how completely Mons. Menabrea has been imbued with the true spirit of the invention. Indeed the whole of the above Memoir is a striking production, when we consider that Mons. Menabrea had had but very slight means for obtaining any adequate ideas respecting the Analytical Engine. It requires however a considerable acquaintance with the abstruse and complicated nature of such a subject, in order fully to appreciate the penetration of the writer who could take so just and comprehensive a view of it upon such limited opportunity.

[^l-6]: This adjustment is done by hand merely.
