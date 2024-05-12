# Prime Cuts Puzzle Solver

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

## Second Implementation

This is the second implementation, using newer crossnumber features.

```
+--+--+--+--+--+--+
|1 |2 :3 :4 |5 :6 |
+::+--+::+::+--+::+
|7 :8 :  |9 :10|  |
+--+::+--+::+::+::+
|11:  |12:  |13:  |
+::+::+::+--+::+--+
|  |14:  |15:  :16|
+::+--+::+::+--+::+
|17:  |18:  :  |  |
+--+--+--+--+--+--+

Across  Value               Prime           Grid                        
A2      Multiple of gA2     B               
A5      Square              C                                           
A7      Multiple of D       D               Multiple of D               
A9      Multiple of R       F               Reverse of another entry    
A11     Ascending digits    G               Factor of gD11              
A12     Triangular          H               Triangular                  
A13     Prime               J                                           
A14     Triangular          K                                           
A15     Cube of D           L               Square of S                 
A17     Square              M reverse C     Reverse of gD3              
A18     Multiple H          N ascending     Multiple  of W              
Down                                                                    
D1      Multiple of P       P=Triangular-Z                              
D3      Square              Q                                           
D4      Multiple of B       R                                           
D6      Palindrome          S               K x T                       
D8      Descending digits   T                                           
D10     Ascending digits,   V                                           
        Divisible by sum digits
D11     Ascending digits    W               G + W                       
D12     Same sum digits A18 X               Jumble gA18                 
D15     Square              Y=reverse Q                                 
D16     Multiple of Z       Z               Square - gD1                

```

## Lessons Learned

These changes were made:
- Debug ability to set known answer, which is checked during solve
- Reverse function is order Unknown
- Clue solver tests clue and expression values nested, and checks primes for each
- Clue solver spots clue reference to its own entry value