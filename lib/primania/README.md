# Primania Puzzle Solver

## Puzzle

Primania by Arden

The prime factors of each of the numbers given below must be found. Each value is the product of a 2-digit prime and a 3-digit prime. The factors must be used as the down entries in the diagram. Across entries are prime both forwards and backwards. All entries are distinct.

```
+--+--+--+--+--+--+--+--+
+1 :2 :3 :4 |5 |6 :7 :8 +
+::+::+::+::+::+::+::+::+
+9 :  |10:  :  :  |11:  +
+::+--+::+--+::+--+::+--+
+  :12:  |13|  |14:  :15+
+--+::+--+::+--+::+--+::+
+16:  |17:  :18:  |19:  +
+::+::+::+::+::+::+::+::+
+20:  :  |  |21:  :  :  +
+--+--+--+--+--+--+--+--+


Clues
1	$firstfactor 10109
2	$secondfactor 10109
3	$firstfactor 14687
4	$secondfactor 14687
5	$firstfactor 15479
6	$secondfactor 15479
7	$firstfactor 22681
8	$secondfactor 22681
9	$firstfactor 24067
10	$secondfactor 24067
11	$firstfactor 25043
12	$secondfactor 25043
13	$firstfactor 30167
14	$secondfactor 30167
15	$firstfactor 38179
16	$secondfactor 38179
```

## Solution

```Solution Mapping
Entry D1 =  317 (Clue D12)
Entry D2 =  23 (Clue D5)
Entry D3 =  919 (Clue D2)
Entry D4 =  97 (Clue D13)
Entry D5 =  523 (Clue D16)
Entry D6 =  73 (Clue D15)
Entry D7 =  673 (Clue D6)
Entry D8 =  11 (Clue D1)
Entry D12 =  613 (Clue D8)
Entry D13 =  587 (Clue D10)
Entry D14 =  311 (Clue D14)
Entry D15 =  773 (Clue D4)
Entry D16 =  37 (Clue D7)
Entry D17 =  79 (Clue D11)
Entry D18 =  41 (Clue D9)
Entry D19 =  19 (Clue D3)
+--+--+--+--+--+--+--+--+
| 3  2  9  9| 5| 7  6  1|
+           +  +        +
| 1  3| 1  7  2  3| 7| 1|
+   --+   --+   --+  +--+
| 7  6  9| 5| 3| 3  3  7|
+--+   --+  +--+   --+  +
| 3| 1| 7  8  4  1| 1  7|
+  +  +           +     +
| 7  3  9| 7| 1  1  9  3|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  317 (Clue D12)
Entry D2 =  23 (Clue D5)
Entry D3 =  919 (Clue D2)
Entry D4 =  97 (Clue D13)
Entry D5 =  523 (Clue D16)
Entry D6 =  73 (Clue D15)
Entry D7 =  613 (Clue D8)
Entry D8 =  11 (Clue D1)
Entry D12 =  673 (Clue D6)
Entry D13 =  587 (Clue D10)
Entry D14 =  311 (Clue D14)
Entry D15 =  773 (Clue D4)
Entry D16 =  37 (Clue D7)
Entry D17 =  79 (Clue D11)
Entry D18 =  41 (Clue D9)
Entry D19 =  19 (Clue D3)
+--+--+--+--+--+--+--+--+
| 3  2  9  9| 5| 7  6  1|
+           +  +        +
| 1  3| 1  7  2  3| 1| 1|
+   --+   --+   --+  +--+
| 7  6  9| 5| 3| 3  3  7|
+--+   --+  +--+   --+  +
| 3| 7| 7  8  4  1| 1  7|
+  +  +           +     +
| 7  3  9| 7| 1  1  9  3|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  317 (Clue D12)
Entry D2 =  73 (Clue D15)
Entry D3 =  311 (Clue D14)
Entry D4 =  37 (Clue D7)
Entry D5 =  587 (Clue D10)
Entry D6 =  19 (Clue D3)
Entry D7 =  673 (Clue D6)
Entry D8 =  79 (Clue D11)
Entry D12 =  613 (Clue D8)
Entry D13 =  523 (Clue D16)
Entry D14 =  919 (Clue D2)
Entry D15 =  773 (Clue D4)
Entry D16 =  23 (Clue D5)
Entry D17 =  97 (Clue D13)
Entry D18 =  41 (Clue D9)
Entry D19 =  11 (Clue D1)
+--+--+--+--+--+--+--+--+
| 3  7  3  3| 5| 1  6  7|
+           +  +        +
| 1  3| 1  7  8  9| 7| 9|
+   --+   --+   --+  +--+
| 7  6  1| 5| 7| 9  3  7|
+--+   --+  +--+   --+  +
| 2| 1| 9  2  4  1| 1  7|
+  +  +           +     +
| 3  3  7| 3| 1  9  1  3|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  311 (Clue D14)
Entry D2 =  73 (Clue D15)
Entry D3 =  317 (Clue D12)
Entry D4 =  37 (Clue D7)
Entry D5 =  587 (Clue D10)
Entry D6 =  79 (Clue D11)
Entry D7 =  673 (Clue D6)
Entry D8 =  19 (Clue D3)
Entry D12 =  613 (Clue D8)
Entry D13 =  523 (Clue D16)
Entry D14 =  919 (Clue D2)
Entry D15 =  773 (Clue D4)
Entry D16 =  23 (Clue D5)
Entry D17 =  97 (Clue D13)
Entry D18 =  41 (Clue D9)
Entry D19 =  11 (Clue D1)
+--+--+--+--+--+--+--+--+
| 3  7  3  3| 5| 7  6  1|
+           +  +        +
| 1  3| 1  7  8  9| 7| 9|
+   --+   --+   --+  +--+
| 1  6  7| 5| 7| 9  3  7|
+--+   --+  +--+   --+  +
| 2| 1| 9  2  4  1| 1  7|
+  +  +           +     +
| 3  3  7| 3| 1  9  1  3|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  317 (Clue D12)
Entry D2 =  73 (Clue D15)
Entry D3 =  311 (Clue D14)
Entry D4 =  37 (Clue D7)
Entry D5 =  587 (Clue D10)
Entry D6 =  19 (Clue D3)
Entry D7 =  613 (Clue D8)
Entry D8 =  79 (Clue D11)
Entry D12 =  673 (Clue D6)
Entry D13 =  523 (Clue D16)
Entry D14 =  919 (Clue D2)
Entry D15 =  773 (Clue D4)
Entry D16 =  23 (Clue D5)
Entry D17 =  97 (Clue D13)
Entry D18 =  41 (Clue D9)
Entry D19 =  11 (Clue D1)
+--+--+--+--+--+--+--+--+
| 3  7  3  3| 5| 1  6  7|
+           +  +        +
| 1  3| 1  7  8  9| 1| 9|
+   --+   --+   --+  +--+
| 7  6  1| 5| 7| 9  3  7|
+--+   --+  +--+   --+  +
| 2| 7| 9  2  4  1| 1  7|
+  +  +           +     +
| 3  3  7| 3| 1  9  1  3|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  311 (Clue D14)
Entry D2 =  73 (Clue D15)
Entry D3 =  317 (Clue D12)
Entry D4 =  37 (Clue D7)
Entry D5 =  587 (Clue D10)
Entry D6 =  79 (Clue D11)
Entry D7 =  613 (Clue D8)
Entry D8 =  19 (Clue D3)
Entry D12 =  673 (Clue D6)
Entry D13 =  523 (Clue D16)
Entry D14 =  919 (Clue D2)
Entry D15 =  773 (Clue D4)
Entry D16 =  23 (Clue D5)
Entry D17 =  97 (Clue D13)
Entry D18 =  41 (Clue D9)
Entry D19 =  11 (Clue D1)
+--+--+--+--+--+--+--+--+
| 3  7  3  3| 5| 7  6  1|
+           +  +        +
| 1  3| 1  7  8  9| 1| 9|
+   --+   --+   --+  +--+
| 1  6  7| 5| 7| 9  3  7|
+--+   --+  +--+   --+  +
| 2| 7| 9  2  4  1| 1  7|
+  +  +           +     +
| 3  3  7| 3| 1  9  1  3|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  919 (Clue D2)
Entry D2 =  41 (Clue D9)
Entry D3 =  317 (Clue D12)
Entry D4 =  73 (Clue D15)
Entry D5 =  587 (Clue D10)
Entry D6 =  11 (Clue D1)
Entry D7 =  523 (Clue D16)
Entry D8 =  19 (Clue D3)
Entry D12 =  673 (Clue D6)
Entry D13 =  613 (Clue D8)
Entry D14 =  773 (Clue D4)
Entry D15 =  311 (Clue D14)
Entry D16 =  79 (Clue D11)
Entry D17 =  97 (Clue D13)
Entry D18 =  23 (Clue D5)
Entry D19 =  37 (Clue D7)
+--+--+--+--+--+--+--+--+
| 9  4  3  7| 5| 1  5  1|
+           +  +        +
| 1  1| 1  3  8  1| 2| 9|
+   --+   --+   --+  +--+
| 9  6  7| 6| 7| 7  3  3|
+--+   --+  +--+   --+  +
| 7| 7| 9  1  2  7| 3  1|
+  +  +           +     +
| 9  3  7| 3| 3  3  7  1|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  919 (Clue D2)
Entry D2 =  41 (Clue D9)
Entry D3 =  317 (Clue D12)
Entry D4 =  73 (Clue D15)
Entry D5 =  587 (Clue D10)
Entry D6 =  11 (Clue D1)
Entry D7 =  523 (Clue D16)
Entry D8 =  79 (Clue D11)
Entry D12 =  673 (Clue D6)
Entry D13 =  613 (Clue D8)
Entry D14 =  773 (Clue D4)
Entry D15 =  311 (Clue D14)
Entry D16 =  19 (Clue D3)
Entry D17 =  97 (Clue D13)
Entry D18 =  23 (Clue D5)
Entry D19 =  37 (Clue D7)
+--+--+--+--+--+--+--+--+
| 9  4  3  7| 5| 1  5  7|
+           +  +        +
| 1  1| 1  3  8  1| 2| 9|
+   --+   --+   --+  +--+
| 9  6  7| 6| 7| 7  3  3|
+--+   --+  +--+   --+  +
| 1| 7| 9  1  2  7| 3  1|
+  +  +           +     +
| 9  3  7| 3| 3  3  7  1|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  919 (Clue D2)
Entry D2 =  41 (Clue D9)
Entry D3 =  613 (Clue D8)
Entry D4 =  73 (Clue D15)
Entry D5 =  587 (Clue D10)
Entry D6 =  11 (Clue D1)
Entry D7 =  673 (Clue D6)
Entry D8 =  79 (Clue D11)
Entry D12 =  523 (Clue D16)
Entry D13 =  317 (Clue D12)
Entry D14 =  773 (Clue D4)
Entry D15 =  311 (Clue D14)
Entry D16 =  19 (Clue D3)
Entry D17 =  97 (Clue D13)
Entry D18 =  23 (Clue D5)
Entry D19 =  37 (Clue D7)
+--+--+--+--+--+--+--+--+
| 9  4  6  7| 5| 1  6  7|
+           +  +        +
| 1  1| 1  3  8  1| 7| 9|
+   --+   --+   --+  +--+
| 9  5  3| 3| 7| 7  3  3|
+--+   --+  +--+   --+  +
| 1| 2| 9  1  2  7| 3  1|
+  +  +           +     +
| 9  3  7| 7| 3  3  7  1|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  919 (Clue D2)
Entry D2 =  41 (Clue D9)
Entry D3 =  317 (Clue D12)
Entry D4 =  73 (Clue D15)
Entry D5 =  587 (Clue D10)
Entry D6 =  11 (Clue D1)
Entry D7 =  673 (Clue D6)
Entry D8 =  79 (Clue D11)
Entry D12 =  613 (Clue D8)
Entry D13 =  523 (Clue D16)
Entry D14 =  773 (Clue D4)
Entry D15 =  311 (Clue D14)
Entry D16 =  19 (Clue D3)
Entry D17 =  97 (Clue D13)
Entry D18 =  23 (Clue D5)
Entry D19 =  37 (Clue D7)
+--+--+--+--+--+--+--+--+
| 9  4  3  7| 5| 1  6  7|
+           +  +        +
| 1  1| 1  3  8  1| 7| 9|
+   --+   --+   --+  +--+
| 9  6  7| 5| 7| 7  3  3|
+--+   --+  +--+   --+  +
| 1| 1| 9  2  2  7| 3  1|
+  +  +           +     +
| 9  3  7| 3| 3  3  7  1|
+--+--+--+--+--+--+--+--+
Solution Mapping
Entry D1 =  919 (Clue D2)
Entry D2 =  41 (Clue D9)
Entry D3 =  317 (Clue D12)
Entry D4 =  73 (Clue D15)
Entry D5 =  587 (Clue D10)
Entry D6 =  11 (Clue D1)
Entry D7 =  613 (Clue D8)
Entry D8 =  79 (Clue D11)
Entry D12 =  673 (Clue D6)
Entry D13 =  523 (Clue D16)
Entry D14 =  773 (Clue D4)
Entry D15 =  311 (Clue D14)
Entry D16 =  19 (Clue D3)
Entry D17 =  97 (Clue D13)
Entry D18 =  23 (Clue D5)
Entry D19 =  37 (Clue D7)
+--+--+--+--+--+--+--+--+
| 9  4  3  7| 5| 1  6  7|
+           +  +        +
| 1  1| 1  3  8  1| 1| 9|
+   --+   --+   --+  +--+
| 9  6  7| 5| 7| 7  3  3|
+--+   --+  +--+   --+  +
| 1| 7| 9  2  2  7| 3  1|
+  +  +           +     +
| 9  3  7| 3| 3  3  7  1|
+--+--+--+--+--+--+--+--+
Solution count: 11
```

## Lessons Learned

Add Primania puzzle
- Set Clue length from value(s) when known
- Add EntryMixin.setDigit() to set digits of an Entry/Cell
- EntryMixin digit sets are now immutable, so can use UndoStack
- Add AND operator to expressions, result of first operand is returned
- NB cannot add OR operator because of generator loops
- Improve Puzzle superclass clue/entry mapping logic to use UndoStack
- Add specific mapping logic for this puzzle
- Improve logging so some regression changes