echo "Compiling program"

lex no_comment.l

g++ lex.yy.c -ll

./a.out

lex no_ws.l

g++ lex.yy.c -ll

./a.out

lex identifier.l

g++ lex.yy.c -ll

./a.out

rm no_comm.go

g++ SymbolTable.cpp

./a.out