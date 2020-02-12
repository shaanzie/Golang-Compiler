echo "Compiling program"

lex identifier.l

g++ lex.yy.c -ll

./a.out

g++ SymbolTable.cpp

./a.out