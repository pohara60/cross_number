# Chessboard Puzzle Solver

## Puzzle

Chessboard Challenge by Zag

No digit can appear in both shaded and unshaded squares. Functions of a number such as 
multiple or divisor are non-trivial producing a different result to the number itself. No answer starts with a zero.
```
+--+--+--+--+
|1 :  |2 :3 |
+::+--+::+::+
|4 :5 :  |  |
+::+::+--+::+
|  |6 :7 :  |
+--+::+::+--+
|8 :  |9 :  |
+--+--+--+--+

Across 
1 sum(entered digits) [2]
2 prime [2]
4 multiple(8ac) [3]
6 divisor(5dn) [3]
8 square [2]
9 divided into 1ac leaves remainder 8ac [2]
Down
1 square – 4ac [3]
2 digital product(6ac) [2]
3 square [3]
5 palindrome [3]
7 multiple(9ac) [2]
```

## Solution

```
A1, #sumdigits, values={50}
A2, #prime, values={23}
A4, $multiple A8, values={160}
A6, $divisor D5, values={154}
A8, #square, values={16}
A9, A8 = A1 % #result, values={17}
D1, #square - A4, values={516}
D2, $dp A6, values={20}
D3, #square, values={324}
D5, #palindrome, values={616}
D7, $multiple A9, values={51}
+--+--+--+--+
| 5  0| 2  3|
+   --+     +
| 1  6  0| 2|
+      --+  +
| 6| 1  5  4|
+--+      --+
| 1  6| 1  7|
+--+--+--+--+
```


## Lessons Learned

The puzzle has a clue where the expression does not yield the result: 
    A8 = A1 % #result
I introduced #result as a synonym for #integer that has the side-effect of saving the value to be used as the result of the expression, instead of the computed value (A8 in this case).

The puzzle was solved without using the condition:
    No digit can appear in both shaded and unshaded squares
This condition requires knowing the row/column for entries, which is currently not recorded. Enhancing entry and implementing the check reduced the number of clue iterations slightly.
