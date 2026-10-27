# Note E {orig="Notes by the Translator"}

::: right
*To page 684.*
:::

This example has evidently been chosen on account of its brevity and simplicity, with a view merely to explain the manner in which the engine would proceed in the case of an *analytical calculation containing variables*, rather than to illustrate the *extent of its powers* to solve cases of a difficult and complex nature. The equations of page 679 are in fact a more complicated problem than the present one.

We have not subjoined any diagram of its development for this new example, as we did for the former one, because this is unnecessary after the full application already made of those diagrams to the illustration of M. Menabrea's excellent tables.

It may be remarked that a slight discrepancy exists between the formulæ

$\begin{matrix}
 & {(a + bx')} \\
 & {(A + B\cos'x)}
\end{matrix}$

given in the Memoir as the *data* for calculation, and the *results* of the calculation as developed in the last division of the table which accompanies it. To agree perfectly with this latter, the data should have been given as

$\begin{matrix}
 & {(ax^{0} + bx')} \\
 & {(A\cos^{0}x + B\cos'x).}
\end{matrix}$

The following is a more complicated example of the manner in which the engine would compute a trigonometrical function containing variables. To multiply by

$\begin{matrix}
 & {A + A_{1}\cos\theta + A_{2}\cos 2\theta + A_{3}\cos 3\theta + \ldots} \\
 & {B + B_{1}\cos\theta}
\end{matrix}$

Let the resulting products be represented under the general form (1.)

$C_{0} + C_{1}\cos\theta + C_{2}\cos 2\theta + C_{3}\cos 3\theta + \mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.$

This trigonometrical series is not only in itself very appropriate for illustrating the processes of the engine, but is likewise of much practical interest from its frequent use in astronomical computations. Before proceeding further with it, we shall point out that there are three very distinct classes of ways in which it may be desired to deduce numerical values from any analytical formula.

First. We may wish to find the collective numerical value of the *whole formula*, without any reference to the quantities of which that formula is a function, or to the particular mode of their combination and distribution, of which the formula is the result and representative. Values of this kind are of a strictly arithmetical nature in the most limited sense of the term, and retain no trace whatever of the processes through which they have been deduced. In fact, any one such numerical value may have been attained from an *infinite variety* of data, or of problems. The values for $x$ and $y$ in the two equations (see Note D.), come under this class of numerical results.

Secondly. We may propose to compute the collective numerical value of *each term* of a formula, or of a series, and to keep these results [p. 713]separate. The engine must in such a case appropriate as many columns to *results* as there are terms to compute.

Thirdly. It may be desired to compute the numerical value of various *subdivisions of each term*, and to keep all these results separate. It may be required, for instance, to compute each coefficient separately from its variable, in which particular case the engine must appropriate *two* result-columns to *every term that contains both a variable and coefficient*.

There are many ways in which it may be desired in special cases to distribute and keep separate the numerical values of different parts of an algebraical formula; and the power of effecting such distributions to any extent is essential to the *algebraical* character of the Analytical Engine. Many persons who are not conversant with mathematical studies, imagine that because the business of the engine is to give its results in *numerical notation*, the *nature of its processes* must consequently be *arithmetical* and *numerical*, rather than *algebraical* and *analytical*. This is an error. The engine can arrange and combine its numerical quantities exactly as if they were *letters* or any other *general* symbols; and in fact it might bring out its results in algebraical *notation*, were provisions made accordingly. It might develope three sets of results simultaneously, viz. *symbolic* results (as already alluded to in Notes A. and B.); *numerical* results (its chief and primary object); and *algebraical* results in *literal* notation. This latter however has not been deemed a necessary or desirable addition to its powers, partly because the necessary arrangements for effecting it would increase the complexity and extent of the mechanism to a degree that would not be commensurate with the advantages, where the main object of the invention is to translate into *numerical* language general formulæ of analysis already known to us, or whose laws of formation are known to us. But it would be a mistake to suppose that because its *results* are given in the *notation* of a more restricted science, its *processes* are therefore restricted to those of that science. The object of the engine is in fact to give the *utmost practical efficiency* to the resources of *numerical interpretations* of the higher science of analysis, while it uses the processes and combinations of this latter.

To return to the trigonometrical series. We shall only consider the four first terms of the factor ($A + A_{1}\cos\theta +$&c., since this will be sufficient to show the method. We propose to obtain separately the numerical value of *each coefficient* $C_{0}$, $C_{1}$, &c. of (1.). The direct multiplication of the two factors gives

$\left. \begin{matrix}
{BA} & {+ BA_{1}\cos\theta} & {+ BA_{2}\qquad\cos 2\theta} & {+ BA_{3}\qquad\cos 3\theta} & {+ \mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.} \\
 & {+ B_{1}A\cos\theta} & {+ B_{1}A_{1}\cos\theta.\cos\theta} & {+ B_{1}A_{2}\cos 2\theta.\cos 2\theta} & {+ B_{1}A_{3}\cos 3\theta.\cos\theta}
\end{matrix} \right\}$(2.)

a result which would stand thus on the engine:—

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: (auto, auto, auto, auto, auto, auto, auto, ),
    align: (auto,auto,auto,auto,auto,auto,auto,),
    table.cell(colspan: 7)[Variables for Data.],
    table.cell(colspan: 7)[$overbrace(quad quad quad quad quad quad quad quad quad quad quad quad)$],
    [$upright(bold(V))_0$], [$upright(bold(V))_1$], [$upright(bold(V))_2$], [$upright(bold(V))_3 #h(0.500em) dot.op #h(0.500em) dot.op$], [$. #h(0.500em) . #h(0.500em) .$], [$dot.op #h(0.500em) dot.op #h(0.500em) upright(bold(V))_10$], [$upright(bold(V))_11$],
    [$A$], [$A_1$], [$A_2$], [$A_3$], [], [$B$], [$B_1$],
    [], [$cos theta$], [$cos 2 theta$], [$cos 3 theta$], [], [], [$cos theta$],
  )]
  , kind: table
  )
]
```

[p. 714]

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: (auto, auto, auto, auto, auto, auto, auto, auto, auto, ),
    align: (auto,auto,auto,auto,auto,auto,auto,auto,auto,),
    table.cell(colspan: 9)[Variables for Results.],
    table.cell(colspan: 9)[$overbrace(quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad quad)$],
    [$upright(bold(V))_20$], [$upright(bold(V))_21$], [$upright(bold(V))_22$], [$upright(bold(V))_23 #h(0.500em) dot.op #h(0.500em) dot.op$], table.cell(rowspan: 4)[ ], [$dot.op #h(0.500em) dot.op #h(0.500em) upright(bold(V))_31$], [$upright(bold(V))_32$], [$upright(bold(V))_33$], [$upright(bold(V))_34$],
    [$B A$], [$B A_1$], [$B A_2$], [$B A_3$], [$B_1 A$], [$B_1 A_1$], [$B_1 A_2$], [$B_1 A_3$],
    [], [$cos theta$], [$cos 2 theta$], [$cos 3 theta$], [$cos theta$], [$\(cos theta . cos theta\)$], [$dots.v$], [$\(cos 3 theta . cos theta\)$],
    table.cell(colspan: 4)[], [$\(cos 2 theta . cos theta\)$], [], [], [],
  )]
  , kind: table
  )
]
```

The variable belonging to each coefficient is written below it, as we have done in the diagram, by way of memorandum. The only further reduction which is at first apparently possible in the preceding result, would be the addition of $\mathbf{V}_{21}$ to $\mathbf{V}_{31}$ (in which case $B_{1}A$ should be effaced from $\mathbf{V}_{31}$). The whole operations from the beginning would then be—

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: (auto, auto, auto, ),
    align: (auto,auto,auto,),
    [First Series of \ Operations.

    $""^1 upright(bold(V))_10 times^1 upright(bold(V))_0 =^1 upright(bold(V))_20$ \ $""^1 upright(bold(V))_10 times^1 upright(bold(V))_1 =^1 upright(bold(V))_21$ \ $""^1 upright(bold(V))_10 times^1 upright(bold(V))_2 =^1 upright(bold(V))_22$ \ $""^1 upright(bold(V))_10 times^1 upright(bold(V))_3 =^1 upright(bold(V))_23$

    ], [Second Series of \ Operations.

    $""^1 upright(bold(V))_11 times^1 upright(bold(V))_0 =^1 upright(bold(V))_31$ \ $""^1 upright(bold(V))_11 times^1 upright(bold(V))_1 =^1 upright(bold(V))_32$ \ $""^1 upright(bold(V))_11 times^1 upright(bold(V))_2 =^1 upright(bold(V))_33$ \ $""^1 upright(bold(V))_11 times^1 upright(bold(V))_3 =^1 upright(bold(V))_34$

    ], [Third Series, which contains \ only one (final) operation.

    $""^1 upright(bold(V))_21 +^1 upright(bold(V))_31 =^2 upright(bold(V))_21$, and \ $upright(bold(V))_31$ becomes $= 0$.

    ],
  )]
  , kind: table
  )
]
```

We do not enter into the same detail of *every* step of the processes as in the examples of Notes D. and G., thinking it unnecessary and tedious to do so. The reader will remember the meaning and use of the upper and lower indices, &c., as before explained.

To proceed: we know that (3.)

$\cos n\theta.\cos\theta = \frac{1}{2}\cos\bar{n + 1}\theta + \frac{1}{2}\bar{n - 1}.\theta\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.$

Consequently, a slight examination of the second line of (2.) will show that by making the proper substitutions, (2.) will become

```{=typst}
#vb-small-table[
#figure(
  align(center)[#table(
    columns: 5,
    align: (right,auto,auto,auto,auto,),
    table.cell(align: right)[$B A$], [$+ B A_1 thick thick . cos theta$], [$+ B A_2 thick thick . cos 2 theta$], [$+ B A_3 . cos 3 theta$], [],
    [], [$+ B_1 A . cos theta$], [], [], [],
    [$+ 1 / 2 B_1 A_1$], [], [$+ 1 / 2 B_1 A_1 . cos 2 theta$], [], [],
    [], [$+ 1 / 2 B_1 A_2 . cos theta$], [], [$+ 1 / 2 B_1 A_2 . cos 3 theta$], [],
    [], [], [$+ 1 / 2 B_1 A_3 . cos 2 theta$], [], [$+ 1 / 2 B_1 A_3 . cos 4 theta$],
    [$C_0$], [$C_1$], [$C_2$], [$C_3$], [$C_4$],
    table.cell(colspan: 5)[These coefficients should respectively appear on],
    [$upright(bold(V))_20$], [$upright(bold(V))_21$], [$upright(bold(V))_22$], [$upright(bold(V))_23$], [$upright(bold(V))_24$],
  )]
  , kind: table
  )
]
```

We shall perceive, if we inspect the particular arrangement of the results in (2.) on the Result-columns as represented in the diagram, that, in order to effect this transformation, each successive coefficient upon $\mathbf{V}_{32}$, $\mathbf{V}_{33}$, &c. (beginning with $\mathbf{V}_{32}$), must through means of proper cards be divided by *two*[^l-10]; and that one of the halves thus [p. 715]obtained must be added to the coefficient on the Variable which precedes it by ten columns, and the other half to the coefficient on the Variable which precedes it by twelve columns; $\mathbf{V}_{32}$, $\mathbf{V}_{33}$, &c. themselves becoming zeros during the process.

This series of operations may be thus expressed:—

Fourth Series.

[^l-11]$\begin{matrix}
 & \left\{ \begin{matrix}
 & {^{1}\mathbf{V}_{32} \div 2 +^{1}\mathbf{V}_{22} =^{2}V_{22} = BA_{2} + \frac{1}{2}B_{1}A_{1}} & \\
 & {^{1}\mathbf{V}_{32} \div 2 +^{1}\mathbf{V}_{20} =^{2}\mathbf{V}_{20} = BA + \frac{1}{2}B_{1}A_{1}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.} & {= C_{0}}
\end{matrix} \right. \\
 & \left\{ \begin{matrix}
 & {^{1}\mathbf{V}_{33} \div 2 +^{1}\mathbf{V}_{23} =^{2}\mathbf{V}_{23} = BA_{3} + \frac{1}{2}B_{1}A_{2}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.} & {= C_{3}} \\
 & {^{1}\mathbf{V}_{33} \div 2 +^{2}\mathbf{V}_{21} =^{3}\mathbf{V}_{21} = BA_{1} + B_{1}A + \frac{1}{2}B_{1}A_{2}} & {= C_{1}}
\end{matrix} \right. \\
 & \left\{ \begin{matrix}
 & {^{1}\mathbf{V}_{34} \div 2 +^{0}\mathbf{V}_{24} =^{1}\mathbf{V}_{24} = \frac{1}{2}B_{1}A_{3}\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.\mspace{9mu}.} & {= C_{4}} \\
 & {^{1}\mathbf{V}_{34} \div 2 +^{2}\mathbf{V}_{22} =^{3}\mathbf{V}_{22} = BA_{2} + \frac{1}{2}B_{1}A_{1} + \frac{1}{2}B_{1}A_{3}} & {= C_{2}.}
\end{matrix} \right.
\end{matrix}$

The calculation of the coefficients $C_{0}$, $C_{1}$, &c. of (1.), would now be completed, and they would stand ranged in order on $\mathbf{V}_{20}$, $\mathbf{V}_{21}$, &c. It will be remarked, that from the moment the fourth series of operations is ordered, the Variables $\mathbf{V}_{31}$, $\mathbf{V}_{32}$, &c. cease to be *Result*-Variables, and become mere *Working*-Variables.

The substitution made by the engine of the processes in the second side of (3.) for those in the first side, is an excellent illustration of the manner in which we may arbitrarily order it to substitute any function, number, or process, at pleasure, for any other function, number or process, on the occurrence of a specified contingency.

We will now suppose that we desire to go a step further, and to obtain the numerical value of each *complete* term of the product (1.), that is of each *coefficient and variable united*, which for the $(n + 1)$th term would be $C_{n}.\cos n\theta$.

We must for this purpose place the variables themselves on another set of columns, $\mathbf{V}_{41}$, $\mathbf{V}_{42}$, &c., and then order their successive multiplication by $\mathbf{V}_{21}$, $\mathbf{V}_{22}$, &c., each for each. There would thus be a final series of operations as follows:—

Fifth and Final Series of Operations.

$\begin{matrix}
{^{2}\mathbf{V}_{20} \times^{0}\mathbf{V}_{40} =^{1}\mathbf{V}_{40}} \\
{^{3}\mathbf{V}_{21} \times^{0}\mathbf{V}_{41} =^{1}\mathbf{V}_{41}} \\
{^{3}\mathbf{V}_{22} \times^{0}\mathbf{V}_{42} =^{1}\mathbf{V}_{42}} \\
{^{2}\mathbf{V}_{23} \times^{0}\mathbf{V}_{43} =^{1}\mathbf{V}_{43}} \\
{^{1}\mathbf{V}_{24} \times^{0}\mathbf{V}_{44} =^{1}\mathbf{V}_{44}}
\end{matrix}$

(N.B. that $\mathbf{V}_{40}$ being intended to receive the coefficient on $\mathbf{V}_{20}$ which has *no* variable, will only have $\cos 0\theta( = 1)$ inscribed on it, preparatory to commencing the fifth series of operations.)

From the moment that the fifth and final series of operations is ordered, the Variables $\mathbf{V}_{20}$, $\mathbf{V}_{21}$, &c. then in their turn cease to be [p. 716]*Result*-Variables and become mere *Working*-Variables; $\mathbf{V}_{40}$, $\mathbf{V}_{41}$, &c. being now the recipients of the ultimate results.

We should observe, that if the variables $\cos\theta$, $\cos 2\theta$, $\cos 3\theta$, &c. are furnished, they would be placed directly upon $\mathbf{V}_{41}$, $\mathbf{V}_{42}$, &c., like any other data. If not, a separate computation might be entered upon in a separate part of the engine, in order to calculate them, and place them on $\mathbf{V}_{41}$, &c.

We have now explained how the engine might compute (1.) in the most direct manner, supposing we knew nothing about the *general* term of the resulting series. But the engine would in reality set to work very differently, whenever (as in this case) we *do* know the law for the general term.

The two first terms of (1.) are (4.)

$(BA + \frac{1}{2}B_{1}A_{1}) + (\bar{BA_{1} + B_{1}A + \frac{1}{2}B_{1}A_{2}}.\cos\theta)\ldots\ldots$

and the general term for all after these is (5.)

$(BA_{n} + \frac{1}{2}B_{1}.\bar{A_{n - 1} + A_{n + 2}})\cos n\theta\ldots\ldots\ldots\ldots$

which is the coefficient of the $(n + 1)^{th}$ term. The engine would calculate the two first terms by means of a separate set of suitable Operation-cards, and would then need another set for the third term; which last set of Operation-cards would calculate all the succeeding terms *ad infinitum*; merely requiring certain new Variable-cards for each term to direct the operations to act on the proper columns. The following would be the successive sets of operations for computing the coefficients of $n + 2$ terms:—

$( \times , \times , \div , + ),( \times , \times , \times , \div , + , + ),n( \times , + , \times , \div , + ).$

Or we might represent them as follows, according to the numerical order of the operations:—

$(1,2\ldots 4),\mspace{9mu}(5,6\ldots 10),n(11,12\ldots 15)$.

The brackets, it should be understood, point out the relation in which the operations may be *grouped*, while the comma marks *succession*. The symbol $+$ might be used for this latter purpose, but this would be liable to produce confusion, as $+$ is also necessarily used to represent one class of the actual operations which are the subject of that succession. In accordance with this meaning attached to the comma, care must be taken when any one group of operations recurs more than once, as is represented above by $n(11\ldots 15)$, not to insert a comma after the number or letter prefixed to that group, $n,(11\ldots 15)$ would stand for *an operation* $n$, *followed by the group of operations* $(11\ldots 15)$; instead of denoting *the number of groups which are to follow each other*. Wherever a *general term* exists, there will be a *recurring group* of operations, as in the above example. Both for brevity and for distinctness, a *recurring group* is called a *cycle*. A *cycle* of operations, then, must be understood to signify any *set of operations* which is repeated *more than once*. It is equally a *cycle*, whether it be repeated *twice* only, or an indefinite number of times; for it is the fact of a *repetition occurring at all* that constitutes it such. In many cases of [p. 717]analysis there is a *recurring group* of one or more *cycles*; that is, a *cycle of a cycle*, or a *cycle of cycles*. For instance: suppose we wish to divide a series by a series, (1.)

$\frac{a + bx + cx^{2} + .\ldots.}{a' + b'x + c'x^{2} + .\ldots.}$,

it being required that the result shall be developed, like the dividend and the divisor, in successive powers of $x$. A little consideration of (1.), and of the steps through which algebraical division is effected, will show that (if the denominator be supposed to consist of $p$ terms) the first partial quotient will be completed by the following operations:— (2.)

$\left\{ ( \div ),p( \times , - ) \right\}\quad$ or $\left\{ (1),p(2,3) \right\}$,

that the second partial quotient will be completed by an exactly similar set of operations, which acts on the remainder obtained by the first set, instead of on the original dividend. The whole of the processes therefore that have been gone through, by the time the *second* partial quotient has been obtained, will be,— (3.)

$2\left\{ ( \div ),p( \times , - ) \right\}\quad$ or $2\left\{ (1),p(2,3) \right\}$,

which is a cycle that includes a cycle, or a cycle of the second order. The operations for the *complete* division, supposing we propose to obtain $n$ terms of the series constituting the quotient, will be,— (4.)

$n\left\{ ( \div ),p( \times , - ) \right\}\quad$ or $n\left\{ (1),p(2,3) \right\}$.

It is of course to be remembered that the process of algebraical division in reality continues *ad infinitum*, except in the few exceptional cases which admit of an exact quotient being obtained. The number $n$ in the formula (4.), is always that of the number of terms we propose to ourselves to obtain; and the $n$th partial quotient is the coefficient of the $(n - 1)$th power of $x$. There are some cases which entail *cycles of cycles of cycles*, to an indefinite extent. Such cases are usually very complicated, and they are of extreme interest when considered with reference to the engine. The algebraical development in a series, of the $n$th function of any given function, is of this nature. Let it be proposed to obtain the $n$th function of (5.)

$\phi(a,b,c\ldots\ldots x),\mspace{9mu} x$ being the variable.

We should premise that we suppose the reader to understand what is meant by an $n$th function. We suppose him likewise to comprehend distinctly the difference between developing *an* $n$th *function algebraically*, and merely *calculating an* $n$th *function arithmetically*. If he does not, the following will be by no means very intelligible; but we have not space to give any preliminary explanations. To proceed: the law, according to which the successive functions of (5.) are to be developed, must of course first be fixed on. This law may be of very various kinds. We may propose to obtain our results in successive *powers* of $x$, in which case the general form would be

$C + C_{1}x + C_{2}x^{2} +$ &c.,

[p. 718]or in successive powers of $n$ itself, the index of the function we are ultimately to obtain, in which case the general form would be

$C + C_{1}n + C_{2}n^{2} +$ &c.,

and $x$ would only enter in the coefficients. Again, other functions of $x$ or of $n$ instead of *powers*, might be selected. It might be in addition proposed, that the coefficients themselves should be arranged according to given functions of a certain quantity. Another mode would be to make equations arbitrarily amongst the coefficients only, in which case the several functions, according to either of which it might be possible to develop the $n$th function of (5.), would have to be determined from the combined consideration of these equations and of (5.) itself.

The *algebraical* nature of the engine (so strongly insisted on in a previous part of this Note) would enable it to follow out any of these various modes indifferently; just as we recently showed that it can distribute and separate the numerical results of any one prescribed series of processes, in a perfectly arbitrary manner. Were it otherwise, the engine could merely *compute the arithmetical* $n$th *function*, a result which, like any other purely arithmetical results, would be simply a collective number, bearing no traces of the data or the processes which had led to it.

Secondly, the *law* of development for the $n$th function being selected, the next step would obviously be to develope (5.) itself, according to this law. This result would be the first function, and would be obtained by a determinate series of processes. These in most cases would include amongst them one or more *cycles* of operations.

The third step (which would consist of the various processes necessary for effecting the actual substitution of the series constituting the *first function*, for the *variable* itself) might proceed in either of two ways. It might make the substitution either wherever $x$ occurs in the original (5.), or it might similarly make it wherever $x$ occurs in the first function itself which is the equivalent of (5.). In some cases the former mode might be best, and in others the latter.

Whichever is adopted, it must be understood that the result is to appear arranged in a series following the law originally prescribed for the development of the $n$th function. This result constitutes the second function; with which we are to proceed exactly as we did with the first function, in order to obtain the third function; and so on, $n - 1$ times, to obtain the $n$th function. We easily perceive that since every successive function is arranged in a series *following the same law*, there would (after the *first* function is obtained) be a *cycle, of a cycle, of a cycle*, &c. of operations[^l-12], one, two, three, up to $n - 1$ times, in order to get the $n$th function. We say, *after the first function is obtained*, because (for reasons on which we cannot here enter) the *first* [p. 719]function might in many cases be developed through a set of processes peculiar to itself, and not recurring for the remaining functions.

We have given but a very slight sketch, of the principal *general* steps which would be requisite for obtaining an $n$th function of such a formula as (5.). The question is so exceedingly complicated, that perhaps few persons can be expected to follow, to their own satisfaction, so brief and general a statement as we are here restricted to on this subject. Still it is a very important case as regards the engine, and suggests ideas peculiar to itself, which we should regret to pass wholly without allusion. Nothing could be more interesting than to follow out, in every detail, the solution by the engine of such a case as the above; but the time, space and labour this would necessitate, could only suit a very extensive work.

To return to the subject of *cycles* of operations: some of the notation of the integral calculus lends itself very aptly to express them: (2.) might be thus written:— (6.)

$( \div ),\Sigma( + 1)^{p}( \times , - )$ or $(1),\Sigma( + 1)^{p}(2,3)$,

where $p$ stands for the variable; $( + 1)^{p}$ for the function of the variable, that is, for $\phi p$; and the limits are from 1 to $p$, or from 0 to $p - 1$, each increment being equal to unity. Similarly, (4.) would be,— (7.)

$\Sigma( + 1)^{n}\left\{ ( \div ),\Sigma( + 1)^{p}( \times , - ) \right\}$

the limits of $n$ being from 1 to $n$, or from 0 to $n - 1$, (8.)

or $\Sigma( + 1)^{n}\left\{ (1),\Sigma( + 1)^{p}(2,3) \right\}$.

Perhaps it may be thought that this notation is merely a circuitous way of expressing what was more simply and as effectually expressed before; and, in the above example, there may be some truth in this. But there is another description of cycles which *can* only effectually be expressed, in a condensed form, by the preceding notation. We shall call them *varying cycles.* They are of frequent occurrence, and include successive cycles of operations of the following nature:— (9.)

$p(1,2,{..}m),\bar{p - 1}(1,2\ldots m),\bar{p - 2}(1,{2..}m)\ldots\bar{p - n}(1,{2..}m)$,

where each cycle contains the same group of operations, but in which the number of repetitions of the group varies according to a fixed rate, with every cycle. (9.) can be well expressed as follows:— (10.)

$\Sigma p(1,2,{..}m)$, the limits of $p$ being from $p - n$ to $p$.

Independent of the intrinsic advantages which we thus perceive to result in certain cases from this use of the notation of the integral calculus, there are likewise considerations which make it interesting, from the connections and relations involved in this new application. It has been observed in some of the former Notes, that the processes used in analysis form a logical system of much higher generality than the applications to number merely. Thus, when we read over any algebraical formula, considering it exclusively with reference to the processes of the engine, and putting aside for the moment its abstract signification as to the relations of quantity, the symbols $+$, $\times$, &c., in reality represent (as their immediate and proximate effect, when the formula is [p. 720]applied to the engine) that a certain prism which is a part of the mechanism (see Note C), turns a new face, and thus presents a new card to act on the bundles of levers of the engine; the new card being perforated with holes, which are arranged according to the peculiarities of the operation of addition, or of multiplication, &c. Again, the *numbers* in the preceding formula (8.), each of them really represents one of these very pieces of card that are hung over the prism.

Now in the use made in the formulæ (7.), (8.) and (10.), of the notation of the integral calculus, we have glimpses of a similar new application of the language of the *higher* mathematics. $\Sigma$, in reality, here indicates that when a certain number of cards have acted in succession, the prism over which they revolve must *rotate backwards*, so as to bring those cards into their former position; and the limits 1 to $n$, 1 to $p$, &c., regulate how often this backward rotation is to be repeated.A. A. L.

[^l-10]: This division would be managed by ordering the number two to appear on any separate new column which should be conveniently situated for the purpose, and then directing this column (which is in the strictest sense a *Working*-Variable) to divide itself successively with $\mathbf{V}_{32}$, $\mathbf{V}_{33}$, &c.

[^l-11]: It should be observed, that were the rest of the factor ($A + \Lambda\cos\theta +$&c.) taken into account, instead of *four* terms only, $C_{3}$ would have the additional term $\frac{1}{2}B_{1}A_{4}$; and $C_{4}$, the two additional terms, $BA_{4}$, $\frac{1}{2}B_{1}A_{5}$. This would indeed have been the case had even *six* terms been multiplied.

[^l-12]: A cycle that includes $n$ other cycles, successively *contained one within another*, is called a cycle of the $n + 1$th order. A cycle may simply *include* many other cycles, and yet only be of the second order. If a series follows a certain law for a certain number of terms, and then another law for another number of terms, there will be a cycle of operations for every new law; but these cycles will not be *contained one within another*,—they merely *follow each other*. Therefore their number may be infinite without influencing the *order* of a cycle that includes a repetition of such a series.
