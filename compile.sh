echo "Compiling program"

lex lexers/no_comment.l

g++ lex.yy.c -ll

./a.out

lex lexers/no_ws.l

g++ lex.yy.c -ll

./a.out

lex lexers/identifier.l

g++ lex.yy.c -ll

./a.out

rm no_comm.go

g++ lexers/SymbolTable.cpp

./a.out

rm identifiers.txt

rm lex.yy.c

rm a.out