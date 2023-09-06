# Wheels of the Bus Puzzle Solver

## Introduction

The Wheels on the Bus by Moog									
									
Muffit and Duffit operate a daily coach service from Aberdeen to Edinburgh which has a single
stop, in order, at Brechin, Crieff and Dundee before reaching its destination. The coach can
hold a maximum of 60 passengers. All entries are distinct and none start with zero.

+--+--+--+--+--+--+
|1 :  :2 |  |3 :4 |
+::+--+::+--+--+::+
|  |  |5 :  |  |  |
+--+--+::+--+--+::+
|  |6 :  |  |7 :  |
+--+::+--+--+::+--+
|8 :  |  |9 :  |  |
+::+--+--+::+--+--+
|  |  |10:  |  |11|
+::+--+--+::+--+::+
|12:  |  |13:  :  |
+--+--+--+--+--+--+


Across
1,square of 1dn,3
3,number who got on at Brechin,2
5,total number of passengers carried,2
6,fare from Aberdeen to Edinburgh in pounds,2
7,square of the number who got off at Brechin,2
8,fare from Dundee to Edinburgh in pounds,2
9,cube of the number who got on at Crieff
10,number who arrived in Edinburgh,2
12,factor of 3ac,2
13,square of 11dn,3

Down
1,number of passengers who got on at Aberdeen,2
2,twenty times the driver’s age in years,3
4,square of 3ac,3
6,less than 3ac,2
7,number who got off at Crieff,2
8,square of 8ac,3
9,cube of the number who got off at Dundee,3
11,number who got on at Dundee,2

## Variables

Variable										Min	Max	Relation
B	number who got on at Brechin				1	60	<=60-A+b
T	total number of passengers carried			1		=A+B+C+D =b+c+d+e
F	fare from Aberdeen to Edinburgh in pounds					1		
b	number who got off at Brechin				1	60	<=A
f	fare from Dundee to Edinburgh in pounds		1		<F
C	number who got on at Crieff					1	60	<=60-A+b-B+c
e	number who arrived in Edinburgh				1	60	=A+B+C+D-b-c-d
A	number of passengers who got on at Aberdeen	1	60	
c	number who got off at Crieff				1	60	<=A-b+B
d	number who got off at Dundee				1	60	<=A-b+B-c+C
D	number who got on at Dundee					1	60	<=60-A+b-B+c-C+d
Y	the driver’s age in years					17	50	


## Enhancements

ExpressionVariables have constraints in terms of expressions involving other variables (not yet clues). The solve queue now consists of Clues and ExpressionVariables (both extend Variable).

Solving a Clue/Variable can set other Clues and/or Variables - these must then be "solved" to execute their side effects (other Clue/Variables values, Entry digits).

## Manual Solution Path

D8 = A8*A8	        A8=[11..14], D8=121, 144, 169, 196
D4 = A3*A3	        A3=11..31, 
A12 = factor A3 	A12=10..31
D8 ends 1,2,3	    D8=121, A8=11
D6 ends 1, less A3	D6=11, 21
D2 = 20*Y	        340..980..20
A6 = F	            10, 20
f<F	                F=20,D6=21,A3=22..31
D4 = A3*A3	        A3=22,26, D4 =484,676
A7 square ends 4,6	16,64
D7=c	            11..19, A7=16, b=4, D4=676, A3=26, A12=13
A13 square D11	    D11=11,15,16,20,21,25,26,30,31
D9 cube d	        125, 216, 343, 512, 729, d=5..9
A13 starts 2,3,5,6,9	D11=15,25,26, A11=225,625,676
D9 ends 2,6	        216, 512, d=6,8
A9 cube C	        A9=27, C=3, D9=216, d=6, A13=625,676,D11=25,26
A1 square D1	    12..14, 144,169,196
Var Arith	        e=41,A=14

## Solution

SOLUTION-----------------------------
Puzzle Summary
A1, $square D1, values={196}
A3, B, values={26}
A5, T, values={68}
A6, F, values={20}
A7, $square b, values={16}
A8, f, values={11}
A9, $cube C, values={27}
A10, e, values={41}
A12, $factor A3, values={13}
A13, $square D11, values={625}
D1, A, values={14}
D2, 20 * Y, values={660}
D4, $square A3, values={676}
D6, $lessthan A3, values={21}
D7, c, values={17}
D8, $square A8, values={121}
D9, $cube d, values={216}
D11, D, values={25}
+--+--+--+--+--+--+
| 1  9  6|  | 2  6|
+   --   +--+--   +
| 4|  | 6  8|  | 7|
+--+--+   --+--+  +
|  | 2  0|  | 1  6|
+--+   --+--+   --+
| 1  1|  | 2  7|  |
+   --+--+   --+--+
| 2|  | 4  1|  | 2|
+  +--+--   +--+  +
| 1  3|  | 6  2  5|
+--+--+--+--+--+--+
Variables:
A={14},valueDesc=,min=1,max=60
B={26},valueDesc=$lte (60-A+b),min=1,max=60
C={3},valueDesc=$lte (60-A+b-B+c),min=1,max=60
D={25},valueDesc=$lte (60-A+b-B+c-C+d),min=1,max=60
F={20},valueDesc=,min=1,max=99
T={68},valueDesc=A+B+C+D = b+c+d+e,min=1,max=240
Y={33},valueDesc=,min=17,max=50
b={4},valueDesc=$lte (A),min=1,max=60
c={17},valueDesc=$lte (A-b+B),min=1,max=60
d={6},valueDesc=$lte (A-b+B-c+C),min=1,max=60
e={41},valueDesc=A+B+C+D-b-c-d,min=1,max=60
f={11},valueDesc=$lt F,min=1,max=99
