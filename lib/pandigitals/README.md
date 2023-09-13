# Perplexing Pandigitals Puzzle Solver

## Puzzle
Perplexing Pandigitals by Oyler

In the Clues S, T and P are three 3-digit numbers that between them contain all of the digits from 1 to 9 inclusive such that S is a square number, T a triangular number and P a prime number. The result R of the calculation S + T – P is a 3-digit prime number. X' denotes the reverse of X and X* denotes a jumble of the digits of X. There are no zeros in the grid and all the entries are distinct.

```
+--+--+--+--+--+--+
|A :a :b |Bc:  :d |
+--+::+::+::+--+::+
|C :  |D :  :  |  |
+--+::+::+--+--+::+
|Ee:  :  |Ff:g :  |
+::+--+--+::+::+--+
|  |G :h :  |H :  |
+::+--+::+::+::+--+
|J :  :  |K :  :  |
+--+--+--+--+--+--+

    S           T   P       R = S + T – P
I   HH          e   d'      G
II  H(C+c–h)    J   d'      F
III cc          K   A       f
IV  g'          3E  b-C-c   A*
V   hh          B'  a-cc    D

+--+--+--+--+--+--+
|1 :2 :3 |4 :  :5 |
+--+::+::+::+--+::+
|6 :  |7 :  :  |  |
+--+::+::+--+--+::+
|8 :  :  |9 :10:  |
+::+--+--+::+::+--+
|  |11:12:  |13:  |
+::+--+::+::+::+--+
|14:  :  |15:  :  |
+--+--+--+--+--+--+

    S               T       P           R = S + T – P
I   A13*A13         D8      D5'         A11
II  A13(A6+D4–D12)  A14     D5'         A9
III D4*D4           A15     A1          D9  
IV  D10'            3*A8    D3-A6-D4    A1*
V   D12*D12         A4'     D2-D4*D4    A7

    I       II              III     IV      V
A1                          P       R*
A4                                          T'
A6                                  D3-D4-P
A7                                          R
A8                                  T/3
A9          R
A11 R
A13 √S      S/(A6+D4–D12)
A14         T
A15                         T

D2                                          P+D4*D4
D3                                  P+A6+D4
D4          S/A13-A6+D12    √S      D3-A6-P √(D2-P), 
D5  P'      P'
D8  T
D9                          R
D10                                 S'
D12         A6+D4–S/A13                     √S



,I,II,III,IV,V
A1,,,P,R*
A4,,,,,T'
A6,,,,D3-D4-P
A7,,,,,R
A8,,,,T/3
A9,,R
A11,R
A13,√S,S/(A6+D4–D12)
A14,,T
A15,,,T

D2,,,,,P+D4*D4
D3,,,,P+A6+D4
D4,,S/A13-A6+D12,√S,D3-A6-P,√(D2-P)
D5,P',P'
D8,T
D9,,,R
D10,,,,S'
D12,,A6+D4–S/A13,,,√S

```

## Solution

Puzzle Summary
A1  = 467
A4  = 147
A6  = 37
A7  = 977
A8  = 287
A9  = 199
A11 = 127
A13 = 29
A14 = 325
A15 = 351
D2  = 678
D3  = 797
D4  = 17
D5  = 769
D8  = 253
D9  = 173
D10 = 925
D12 = 25
+--+--+--+--+--+--+
| 4  6  7| 1  4  7|
+--      +   --   +
| 3  7| 9  7  7| 6|
+--   +   --+--+  +
| 2  8  7| 1  9  9|
+   --+--+      --+
| 5| 1  2  7| 2  9|
+  +--      +   --+
| 3  2  5| 3  5  1|
+--+--+--+--+--+--+
Variables:
       S   T   P   R
   I 841 253 967 127
  II 841 325 967 199
 III 289 351 467 173
  IV 529 861 743 647
   V 625 741 389 977

## Lessons Learned

The 5 sets of variable values require a unique solution approach.