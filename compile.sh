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

echo "##########################################################################################################################"

echo "\n\n\nTokens:\n"

cat tokens.txt

lex lexers/identifier.l

g++ lex.yy.c -ll

./a.out

echo "##########################################################################################################################"

rm a.out

lex parsers/parser.l

yacc parsers/parser.y -d 

cc lex.yy.c y.tab.c -o parse -w

./parse < parsed_input.go

g++ lexers/SymbolTable.cpp

echo "\n"

echo "##########################################################################################################################"

echo "\n\n\nSymbol Table:\n\n"

./a.out



echo "##########################################################################################################################"

rm y.tab* parse no_comm.go

rm identifiers.txt

rm error.txt

rm tokens.txt

rm lex.yy.c
