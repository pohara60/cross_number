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
T	total number of passengers carried			1		=B+C+D
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


## Lessons Learned

Need variables that have constraints in terms of expressions other of variables.

## Solution Path

