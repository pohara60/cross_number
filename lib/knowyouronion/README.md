# KnowYourOnion Puzzle Solver

## Puzzle

Know Your Onion by Arden

The first letter in each clue stands for a number of the form XYZXY , the digit Z being sandwiched between the same pair of digits X, Y and this number is inserted in the diagram as  XYZ  or ZXY . The second element of each clue is given as the product of two 3-digit primes, which differ by less than 100. Upper-case  letters denote across entries and lower case down entries and the symbol ′ indicates the reverse of.

```+--+--+--+--+--+--+--+
|A :a :b |B :c :  |d |
+--+::+::+--+::+--+::+
|Ce:  :  |D :  :f |  |
+::+::+::+--+::+::+::+
|  |E :  :g |F :  :  |
+::+--+--+::+--+::+--+
|G :h :  |  |H :  :k |
+--+::+--+::+--+--+::+
|Km:  :n |M :p :q |  |
+::+::+::+--+::+::+::+
|  |N :  :  |P :  :  |
+::+--+::+--+::+::+--+
|  |Q :  :  |R :  :  |
+--+--+--+--+--+--+--+


Clues
I	A	Bm
II	C	e′Q
III	G	Mm
IV	H	aq
V	K	h2
VI	P	fp
VII	R	(D-n′)N
VIII	b	cF
IX	g	dp
X	k	E2
```

## Solution

```Clue I, $xyzxy A | £productTwoThreeDigitPrimes(B,m), values={31831}
Clue II, $xyzxy C | £productTwoThreeDigitPrimes(e',Q), values={73373}
Clue III, $xyzxy G | £productTwoThreeDigitPrimes(M,m), values={29329}
Clue IV, $xyzxy H | £productTwoThreeDigitPrimes(a,q), values={19519}
Clue V, $xyzxy K | £productTwoThreeDigitPrimes(h,h), values={69169}
Clue VI, $xyzxy P | £productTwoThreeDigitPrimes(f,p), values={49949}
Clue VII, $xyzxy R | £productTwoThreeDigitPrimes((D-n'),N), values={99899}
Clue VIII, $xyzxy b | £productTwoThreeDigitPrimes(c,F), values={37837}
Clue IX, $xyzxy g | £productTwoThreeDigitPrimes(d,p), values={33233}
Clue X, $xyzxy k | £productTwoThreeDigitPrimes(E,E), values={29929}
Entry A, values={318}
Entry a, #prime, values={131}
Entry b, values={837}
Entry B, #prime, values={229}
Entry c, #prime, values={241}
Entry d, #prime, values={167}
Entry C, values={733}
Entry e, values={703}
Entry D, values={642}
Entry f, #prime, values={251}
Entry E, #prime, values={173}
Entry g, values={332}
Entry F, #prime, values={157}
Entry G, values={329}
Entry h, #prime, values={263}
Entry H, values={519}
Entry k, values={929}
Entry K, values={169}
Entry m, #prime, values={139}
Entry n, values={953}
Entry M, #prime, values={211}
Entry p, #prime, values={199}
Entry q, #prime, values={149}
Entry N, #prime, values={353}
Entry P, values={949}
Entry Q, #prime, values={239}
Entry R, values={998}
+--+--+--+--+--+--+--+
| 3  1  8| 2  2  9| 1|
+--      +--    --+  +
| 7  3  3| 6  4  2| 6|
+        +--      +  +
| 0| 1  7  3| 1  5  7|
+  +--+--+  +--+   --+
| 3  2  9| 3| 5  1  9|
+--+   --+  +-- --+  +
| 1  6  9| 2  1  1| 2|
+        +--+     +  +
| 3| 3  5  3| 9  4  9|
+  +--+   --+      --+
| 9| 2  3  9| 9  9  8|
+--+--+--+--+--+--+--+
```

## Lessons Learned

Add KnowYourOnion puzzle:
- Puzzle uses custom Monadic and Polyadic functions for XYZXY mapping, and checking valid primes
- Added Square/Root functionality to rearrangeNode, though not actually needed