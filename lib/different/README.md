# Different Puzzle Solver

## Puzzle

Different by Nod

Clues are given in ascending order of entries and equal the difference between the entry and the next highest entry. Clues are numbered for reference only. All entries are distinct and no entry starts with zero.

```+--+--+--+--+--+--+--+
|Aa:b :c |B :d :e :f |
+::+::+::+--+::+::+::+
|  :  |C :g |  |D :  |
+--+::+::+::+::+::+::+
|E :  :  |F :  |  |  |
+::+--+--+::+::+::+::+
|G :h :i |  |H :  :  |
+::+::+::+::+--+--+::+
|  |  |I :  |Jj:k :  |
+::+::+::+::+::+::+--+
|K :  |  |L :  |M :l |
+::+::+::+--+::+::+::+
|N :  :  :  |O :  :  |
+--+--+--+--+--+--+--+

Clues
1	1
2	2
3	3
4	16
5	1
6	1
7	10
8	19
9	1
10	272
11	8
12	12
13	21
14	39
15	47
16	83
17	117
18	3
19	5
20	5855
21	148
22	92
23	361
24	20
25	19
26	35940
27	8
28	32
```

## Solution

```+--+--+--+--+--+--+--+
| 3  5  6| 6  6  7  4|
+        +--         +
| 3  4| 6  4| 5| 1  3|
+--+  +     +  +     +
| 4  6  3| 3  2| 2| 1|
+   --+--+     +  +  +
| 3  7  7| 1| 6  7  1|
+        +  +--+--+  +
| ?| 1| 1  0| 3  4  4|
+  +  +     +      --+
| 4  4| 6| 6  3| 1  1|
+     +  +--+  +     +
| 6  7  6  6| 6  6  6|
+--+--+--+--+--+--+--+

E	C	Value
A	13	356
a	6	33
b	17	546
c	18	663
B	22	6674
d	21	6526
e	24	7127
f	28	43114
C	7	34
D	10	64
g	27	43106
E	3	13
F	16	463
G	5	32
H	14	377
i	25	7147
j	26	7166
I	20	671
J	1	10
K	12	344
k	11	336
l	15	416
L	8	44
M	9	63
N	2	11
m	4	16
O	23	6766
P	19	666

C	Diff	Value
1	1		10
2	2		11
3	3		13
4	16		16
5	1		32
6	1		33
7	10		34
8	19		44
9	1		63
10	272		64
11	8		336
12	12		344
13	21		356
14	39		377
15	47		416
16	83		463
17	117		546
18	3		663
19	5		666
20	5855	671
21	148		6526
22	92		6674
23	361		6766
24	20		7127
25	19		7147
26	35940	7166
27	8		43106
28	32		43114

```

## Lessons Learned

Add Different Puzzle
- No need for expressions
- Backtrack over 45 possible entry start values, fitting clues