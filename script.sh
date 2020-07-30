#! /bin/bash

bison -d sintactico.y
flex lexico.l
gcc lex.yy.c sintactico.tab.c -lm
./a.out