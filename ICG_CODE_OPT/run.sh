# ICG- 

yacc -d ICG.y
lex ICG.l
gcc -g y.tab.c lex.yy.c -ll -o ICG
./ICG

# CODE_OPT

yacc -d opt.y
lex opt.l
gcc -g y.tab.c lex.yy.c -ll -o OPT
./OPT