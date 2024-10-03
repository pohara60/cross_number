# TwoByTwo Puzzle Solver

## Puzzle

2 x 2 = 3 by Czecker

Each 3-digit entry is the last three digits of the product of the two 2-digit entries in its row or column. Only additional information is clued. Entries are  distinct, none starting with a zero.

```+--+--+--+--+--+--+--+
|1 :2 :3 |4 :5 |6 :7 |
+::+::+::+::+::+::+::+
|8 :  |9 :  |10:  :  |
+--+::+--+--+::+--+::+
|11:  :12|13:  |14:  |
+::+--+::+::+--+::+--+
|15:16|17:  :18|19:20|
+--+::+--+::+::+--+::+
|21:  |22:  |23:24:  |
+::+--+::+--+--+::+--+
|25:26:  |27:28|29:30|
+::+::+::+::+::+::+::+
|31:  |32:  |33:  :  |
+--+--+--+--+--+--+--+


Across
1	
4	
6	
8	#cube
9	
10	A8 = $sumDigitSquares #result
11	
13	$reverse A32
14	
15	
17	
19	$prime $reverse A29
21	$multiple D16
22	
23	#cube
24	
25	
27	
29	$prime $reverse A19
31	
32	
33	
Down
1	#power2
2	
3	#palindrome
4	
5	
6	
7	$multiple D5
11	
12	
13	
14	
16	
18	
20	
21	
22	
24	
26	
27	
28	
30
```

## Solution

```A1, £last3digits(A4,A6), values={349}
A4, , values={81}
A6, , values={29}
A8, #cube, values={27}
A9, , values={93}
A10, A8 = $sumDigitSquares #result | £last3digits(A8,A9), values={511}
A11, £last3digits(A13,A14), values={264}
A13, $reverse A32, values={82}
A14, , values={52}
A15, , values={61}
A17, £last3digits(A15,A19), values={819}
A19, $prime $reverse A29, values={79}
A21, $multiple D16, values={84}
A22, , values={74}
A23, #cube | £last3digits(A21,A22), values={216}
A25, £last3digits(A27,A29), values={335}
A27, , values={55}
A29, $prime $reverse A19, values={97}
A31, , values={24}
A32, , values={28}
A33, £last3digits(A31,A32), values={672}
D1, #powerof2, values={32}
D2, £last3digits(D16,D26), values={476}
D3, #palindrome, values={99}
D4, , values={83}
D5, £last3digits(D18,D28), values={152}
D6, , values={21}
D7, $multiple D5 | £last3digits(D20,D30), values={912}
D11, , values={26}
D12, , values={48}
D13, £last3digits(D4,D27), values={814}
D14, , values={57}
D16, , values={14}
D18, , values={92}
D20, , values={96}
D21, £last3digits(D1,D11), values={832}
D22, £last3digits(D3,D12), values={752}
D24, £last3digits(D6,D14), values={197}
D26, , values={34}
D27, , values={58}
D28, , values={56}
D30, , values={72}
+--+--+--+--+--+--+--+
| 3  4  9| 8  1| 2  9|
+        +     +     +
| 2  7| 9  3| 5  1  1|
+--+  +--+--+   --+  +
| 2  6  4| 8  2| 5  2|
+   --+  +   --+   --+
| 6  1| 8  1  9| 7  9|
+--+  +--+     +--+  +
| 8  4| 7  4| 2  1  6|
+   --+   --+--+   --+
| 3  3  5| 5  5| 9  7|
+        +     +     +
| 2  4| 2  8| 6  7  2|
+--+--+--+--+--+--+--+
```

## Lessons Learned

Add TwoByTwo puzzle
- Add generator powerof2
- Add puzzle specific polyadic last3digits(value1,value2)
