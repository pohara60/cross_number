# Excuses Puzzle Solver

## Puzzle

The Listener Crossword No 4843 Excuses, Excuses by Nipper

The letters a to z in the clues represent the integers 1 to 26 in some order. Each clue is an equation of the form A^N + B^N = C^N where A < B < C N < 6 are all positive integers, for each clue the entry in the grid is the value of A^N + B^N. Fermat's Last Theorem states that there are no such equations for N > 2 so most of the clues are wrong, with an error value defined as (the absolute value of) the difference between A^N + B^N and C^N. The clues are given in order of increasing error value. Each perimeter cell must be filled with the letter for the error value of the indicated clue, to show a thematic excuse. All clues with an error that corresponds to a letter are used in the perimeter. There are no leading zeros and all entries are different.

```+--+--+--+--+--+--+--+--+--+
|1 :2 :3 :4 :5 :  :6 |7 :8 |
+::+::+::+::+::+--+::+::+::+
|  :  :9 :  :  |10:  :  :  |
+::+::+::+::+--+::+--+::+::+
|11:  :  :  |12:  :13:  |  |
+::+--+::+::+::+::+::+--+--+
|14:15|16:  :  :  :  |17|18|
+::+::+::+--+::+::+::+::+::+
|  |19:  :20:  :  :  :  |  |
+::+::+::+::+::+--+::+::+::+
|  |  |21:  :  :22:  |23:  |
+--+--+::+::+::+::+::+--+::+
|24|25:  :  :  |26:  :27:  |
+::+::+--+::+--+::+::+::+::+
|28:  :29:  |30:  :  |  |  |
+::+::+::+--+::+::+::+::+::+
|31:  |32:  :  :  :  :  :  |
+--+--+--+--+--+--+--+--+--+



```

## Solution

```Clue 1, f^h + m^h = (l + z)^h, values={841}
Clue 2, (g - n - q)^h + (a + c)^h = f^h, values={400}
Clue 3, (u + y)^h + (v + x)^h = (c + qz)^h, values={3364}
Clue 4, (d + g)^h + (l + y)^h = (qz)^h, values={3025}
Clue 5, c^h + p^h = q^h, values={25}
Clue 6, k^i + n^i = (k + n)^i, values={13}
Clue 7, (m - t)^c + (y - l)^c = (qt - kz)^c, values={728}
Clue 8, (qt - kz)^c + (m - z)^c = (g - r)^c, values={1729}
Clue 9, q^c + (m - t)^c = (x - l)^c, values={341}
Clue 10, d^h + (t + y)^h = (cu)^h, values={1762}
Clue 11, (v - a)^h + d^h = e^h, values={97}
Clue 12, (k + n)^h + (i + x)^h = (d + f)^h, values={845}
Clue 13, (t+v) ^c+(jp+r)^c = (cnq)^c, values={1157632}
Clue 14, (f + j)^h + (eq)^h = (b + f + g)^h, values={4349}
Clue 15, i^h + p^h = q^h, values={17}
Clue 16, r^h + v^h = m^h, values={433}
Clue 17, (e - k)^h + (l - a)^h = (u - n)^h, values={41}
Clue 18, (e + u)^h + (cj)^h = (b + x + y)^h, values={5337}
Clue 19, (x - g)^h + (e - q)^h = (d + q - o)^h, values={26}
Clue 20, (k + n)^q + (g - o)^q = (o + u - q)^q, values={1419869}
Clue 21, (s - d)^c + (ev - of)^c = z^c, values={1343}
Clue 22, p^h + (c + m - e)^h = t^h, values={212}
Clue 23, h^h + (c + q)^h = d^h, values={68}
Clue 24, (q^c)^h + (q^c + b)^h = (bd - q)^h, values={37234}
Clue 25, (p + w) + (hw + k)^c = (hw + o)^c, values={97351}
Clue 26, h^h + d^h = e^h, values={85}
Clue 27, (mq-e)^h + (cez + e)^h = (cez + j)^h, values={124625}
Clue 28, (r + u)^c + (gh + hu)^c = (nz)^c, values={456552}
Clue 29, o^h + e^h = (y - u)^h, values={164}
Clue 30, (t-p)^c + (t - i)^c = (i + t)^c, values={4075}
Clue 31, (y - f)^h + u^h = (p + r)^h, values={232}
Clue 32, (c + h + q)^h + (g + j + m)^h = (l + x + y)^h, values={4724}
Clue 33, (j + y)^h + (mp)^h = (fq - c)^h, values={9457}
Clue 34, o^h + a^h = v^h, values={233}
Clue 35, (hy - k - x)^p + (i + nq)^p = (f + v)^p, values={1874097}
Clue 36, (mqz)^h + (l(q^c)+i)^h= (hjqz)^h, values={6401026}
Clue 37, (bp)^h + (ef)^h = (fz - i)^h, values={47744}
Clue 38, (k^p - hk - hn)^h + (k^p + p^p - c)^h = (h(e^c) + c)^h, values={4012301}
+--+--+--+--+--+--+--+--+--+
| 1  4  1  9  8  6  9| 1  7|
+               --   +     +
| 2| 0| 8  4  5| 1  7  6  2|
+  +  +      --+   --+     +
| 4  0  7  5| 3  3  6  4| 8|
+   --+     +         --+--+
| 6  8| 4  7  7  4  4| 2| 4|
+     +   --+        +  +  +
| 2| 4  0  1  2  3  0  1| 5|
+  +            --+     +  +
| 5| 1| 9  7  3  5  1| 2  6|
+--+--+              +--+  +
| 3| 4  7  2  4| 3  0  2  5|
+  +   --+   --+           +
| 4  3  4  9| 2  3  2| 3| 5|
+         --+        +  +  +
| 1  3| 1  1  5  7  6  3  2|
+--+--+--+--+--+--+--+--+--+
Variables:
a={13}
b={22}
c={3}
d={9}
e={10}
f={20}
g={24}
h={2}
i={1}
j={23}
k={6}
l={18}
m={21}
n={7}
o={8}
p={4}
q={5}
r={12}
s={16}
t={15}
u={14}
v={17}
w={19}
x={25}
y={26}
z={11}

[[t, h, i, s, m, a, r, g, i, n, i], [s], [t], [f, o], [o, o], [o, n], [r, a], [p, r], [e, r], [h, o], [t, n, i, a, t, n, o, c, o, t, w]]


t   h  i  s  m  a  r  g  i  n  i
  +--+--+--+--+--+--+--+--+--+
  | 1  4  1  9  8  6  9| 1  7| s
  +               --   +     +
  | 2| 0| 8  4  5| 1  7  6  2| t
  +  +  +      --+   --+     +
f | 4  0  7  5| 3  3  6  4| 8| o
  +   --+     +         --+--+
o | 6  8| 4  7  7  4  4| 2| 4| o
  +     +   --+        +  +  +
o | 2| 4  0  1  2  3  0  1| 5| n
  +  +            --+     +  +
r | 5| 1| 9  7  3  5  1| 2  6| a
  +--+--+              +--+  +
p | 3| 4  7  2  4| 3  0  2  5| r
  +  +   --+   --+           +
e | 4  3  4  9| 2  3  2| 3| 5| r
  +         --+        +  +  +
h | 1  3| 1  1  5  7  6  3  2| o
  +--+--+--+--+--+--+--+--+--+
 t  n  i  a  t  n  o  c  o  t  w
```

## Lessons Learned

Add Excuses puzzle
- Clue has additional fields a, b, c, n for the respective expresions
- Clue has set of possible differences, with minDiff and maxDiff
- Custom solveClue() that maintains differences computed by solveExcusesClue
- solveExcusesClue() has recursive solveNextExpressionEvaluator() 
  and solveNextExpressionValue(), similar to solveRelatedClue()
- solveNextExpressionValue() checks a < b < c, computes value a^n + b^n and
  difference |c^n - value|
- updateClues() calls updateClueDiffs() to update minDiff and maxDiff for
  other clues when a clue is updated

Future enhancements
- The recursive solveNextExpressionEvaluator() and solveNextExpressionValue(), 
  similar to solveRelatedClue(), could be made reusable with the removal of the unique
  possibleDiff argument, and with extraction of value checking to a callback
- This would allow other puzzles to solve multiple expressions recursively
