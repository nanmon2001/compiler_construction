# Compiler construction
A in-class project from CSCE 531 Compiler Construction, taught in University of South Carolina. 
This project includes mainly two work 1) a baby ccp, c compiler preprocessor, use flex in c code syntax. 
2) simple c compiler, use yacc/bison in c code syntax. 
For more details please see inside the folder or check the course website: https://cse.sc.edu/~fenner/csce531/index.html

The content in each folder is describe as follow:
### hw1_babyccp
This a baby c compiler preprocessor, which generally is a lexer. hw1.1 or hw1.lex are the flex script, 
compile it with all the realated files (check the makefile) to generate an executable (.exe).
The .exe handle the #define statement in .c files and detect if there is a cycle of variable name replacing.
e.g. #define ID1 ID2, #define ID2 ID3, #define ID3 ID1 ---- for this babyccp all ID1, ID2, ID3 will be replace as ID1.
There is a test folder, which includes some example .c code for testing.

### hw2_simple arithmetic parser
A simple arithmetic parser, parse.y is a bison/yacc file, compile it with all the realated file (see makefile) to generate an .exe.
The .exe will check and evaluate arithmetic expressions, further more, it caches the result of each line and can be called later.
e.g. 
line 1: 
a = 1 + 1 
line 2: 
a + 3
line 3:
#2 + 2  >>>>>>>>>> returns the result of 1 + 1 + 3 + 2 = 7

### simple_compiler
A simple compiler, gram.y is a bison/yacc file, compile it with with all the realated file (see makefile) to generate an .exe.
Run .exe on .c files generates assembly code. Example of .c files are included in folder proj4test. 
It can handle global declaration of all basic types (float, int, list, func, etc.), function calls, while loop, for loop, switch, etc. 

**All folder includes a Perl script (.pl file) given by the instructor and a self-made makefile for auto-grading use, 
but the executable can run on its own**  

### Notice
If it does't work, please try on a Linux/Unix machine, because it is required in course to work on a Lab Linux/Unix machine,
window system also works but with less guarantee and might not as expected.
