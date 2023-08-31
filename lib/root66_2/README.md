# Root66 Puzzle Solver

## Introduction

Prime Cuts puzzles have these features:

-   It is a grid, similar to a crossword grid, with numbered clues across and down
-   The clues specify conditions for a 4 or 5 digit Value, a 2 digit Prime whose digits are removed from the Value to give the Grid entry, and the 2 or 3 digit Grid entry. For example:
    -   The Value is a multiple of the Prime
    -   The Prime is the reverse of the Prime for another clue
    -   The Grid entry is a multiple of the Prime
-   The Primes are distinct two digit numbers
-   Grid entries cannot start with 0
-   Numbers that are ascending or descending do not have repeated digits

## Problem Definition

The Listener Crossword No 4764 Root 66 

+--+--+--+--+--+--+--+--+
|  |1 |2 |3 :4 :5 |6 |  |
+--+::+::+::+::+::+::+--+
|7 :  :  :  :  :  :  :  |
+--+::+::+::+::+::+::+--+
|8 :  :  :  |9 :  :  :10|
+::+::+::+::+::+::+::+::+
|11:  :  :  |12:  :  :  |
+::+::+--+--+--+--+::+::+
|13:  :14:15|16:17:  :  |
+::+::+::+::+::+::+::+::+
|18:  :  :  |19:  :  :  |
+--+::+::+::+::+::+::+--+
|20:  :  :  :  :  :  :  |
+--+::+::+::+::+::+::+--+
|  |  |21:  :  :  |  |  |
+--+--+--+--+--+--+--+--+

The clue answers are based on equations of the form (B+ C√66)(E+ F√66) = G + H√66, where B, C, E and F are distinct nonzero digits, G is a positive four-digit integer with no zeros or repeated digits and H is some positive integer. In the clues the letters of DURATIONS stand for the digits 1 to 9 in an order to be determined. In seven cases the answer is a BCEF value, ie 1000B + 100C+ 10E+F, and the grid entry is its G value; the remaining 13 answers are G values and the entry is an associated BCEF value. Each of the unclued entries a, g, h and x consists of a BCEF value followed by its G value. To resolve an ambiguity, solvers must identify a distinctive property that they all share. Solvers must find another BCEF and G pair with the same property, where G is the largest of the five that exist and BCEF is the smallest of its four possible values, and enter them below the grid with their digits converted to the letters used in the clues. All answers are different and all entries are different; normal rules of algebra apply in the clues; VX means the positive square root of X.

Across
2  b -D+UR^(A+T)+I+ON^S
7  h 
8  i R+O(TU+N)DA
9  k (S+I+T^A+RO-U-N)D 
11 n U((N+I)^T-(A+R)D)S
12 o (A+S)T(R^O-√(ID)) 
13 p SU^T+(O+R+I)A+N
16 s (DI-NO)(S+T)A+R
18 v (T/R)I^N(ODU+S)
19 w (TU^N(D+R)+A)S 
20 x 
21 y -(√I)N+TRADO+S
Down
1  a 
2  c -D+U(R+A)(T^I+ON^S) 
3  d DI(N^OS+A+U)R
4  e (AROU+N)D
5  f A(U+D)+(I+T+O)R^S
6  g 
8  j S-A+UT(O+I-R)
10 m (S(U+D-A)-T)IO+N
14 q R-(A+I+N+O-U^T)S
15 r ((N+U)^T+RI+S+O+D)A
16 t R(O(√D-A+UST)-1+N) 
17 u A(S^T+OU+N)+D

## Observations

The square roots must give an integer result, so √D, √I and √(ID) mean that D and are are from {1, 4, 9}.

G = BE+66*CF, so 17<=CF<=72 and 1234<=G<=4794

All expressions give 4 digit values. 
d DI(N^OS+A+U)R, min = 2*3*(6^1*5+7+8)*4 = 1080

j = S-A+U^T(O+I-R)

print(puzzle.clues.values.map((e)=>'${e.name}=${e.valueDesc!=''?e.exp:"none"}').toList())

A2=((((-D)+(U*(R^(A+T))))+I)+(O*(N^S)))
A7=none
A8=(R+(((O((TU)+N))D)A))
A9=((((((S+I)+(T^A))+(RO))-U)-N)D)
A11=((U(((N+I)^T)-((A+R)D)))S)
A12=(((A+S)T)((R^O)-√(ID)))
A13=(((S*(U^T))+(((O+R)+I)A))+N)
A16=(((((DI)-(NO))(S+T))A)+R)
A18=(((T/R)*(I^N))*(((OD)U)+S))
A19=((((T*(U^N))*(D+R))+A)S)
A20=none
A21=(((-(√IN))+((((TR)A)D)O))+S)
D1=none
D2=((-D)+((U(R+A))((T^I)+(O*(N^S)))))
D3=(((DI)((((N^O)*S)+A)+U))R)
D4=(((((AR)O)U)+N)D)
D5=((A(U+D))+(((I+T)+O)*(R^S)))
D6=none
D8=((S-A)+((U^T)*((O+I)-R)))
D10=(((((S((U+D)-A))-T)I)O)+N)
D14=(R-(((((A+I)+N)+O)-(U^T))S))
D15=(((((((N+U)^T)+(RI))+S)+O)+D)A)
D16=(R(((O((√D-A)+((US)T)))-I)+N))
D17=((A(((S^T)+(OU))+N))+D)


