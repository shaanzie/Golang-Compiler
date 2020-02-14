echo "Compiling program"

lex lexers/no_comment.l

g++ lex.yy.c -ll

./a.out

lex lexers/no_ws.l

g++ lex.yy.c -ll

./a.out


lex lexers/token.l

g++ lex.yy.c -ll

./a.out

echo "\n\n\nTokens:\n"

cat tokens.txt

echo "\n\n\nErrors:\n"

cat error.txt

lex lexers/identifier.l

g++ lex.yy.c -ll

./a.out

rm no_comm.go

g++ lexers/SymbolTable.cpp

echo "\n\n\nSymbol Table:\n\n"

./a.out

rm identifiers.txt

rm error.txt

rm tokens.txt

rm lex.yy.c

rm a.out