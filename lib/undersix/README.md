# UnderSix Puzzle Solver

## Puzzle

Everything Under Six by Arden

The 5- or 6-digit number on the left-hand side of each clue has been expressed as the product of two 3-digit numbers, together comprising the six distinct digits under six. Every digit in the completed grid is under six. Upper case denotes across entries and lower case down entries. Normal rules of algebra apply, entries ar e distinct and no entry starts with zero. The ' symbol denotes the reverse of the character immediately before it.

```+--+--+--+--+--+--+
|Aa:b :  |B :c :d |
+::+::+--+--+::+::+
|  |  |e |f |  |  |
+::+::+::+::+::+::+
|C :  :  :  :  :  |
+--+--+::+::+--+--+
|Dg:  :  :  :  :h |
+::+--+::+::+--+::+
|E :  :  |F :  :  |
+::+--+::+::+--+::+
|G :  :  :  :  :  |
+--+--+--+--+--+--+


Across
A	
B	
C	B( F + a - g )
D	ab
E	
F	
G	Ec'
```

## Solution

```
Puzzle Summary
A, , values={450}
B, , values={415}
C, B( F + a - g ), values={125330}
D, ab, values={213332}
E, , values={405}
F, , values={142}
G, Ec', values={130005}
a, , values={401}
b, , values={532}
c, , values={123}
d, , values={530}
e, Ac, values={55350}
f, F(d - h), values={43310}
g, , values={241}
h, , values={225}
+--+--+--+--+--+--+
| 4  5  0| 4  1  5|
+      --+--      +
| 0| 3| 5| 4| 2| 3|
+  +  +  +  +  +  +
| 1  2  5  3  3  0|
+--+--+      --+--+
| 2  1  3  3  3  2|
+   --       --   +
| 4  0  5| 1  4  2|
+   --   +   --   +
| 1  3  0  0  0  5|
+--+--+--+--+--+--+
```

## Lessons Learned

Add Under Six puzzle
- All digits are under six
- Clues have expressions for (some) alphabetic Entries. 
- Constraint on expression operand values.
- Add optional calback to expression evaluation, can reject result values