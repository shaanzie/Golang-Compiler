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

rm y.tab* parse no_comm.go

rm identifiers.txt

rm error.txt

rm tokens.txt

rm lex.yy.c

echo "##########################################################################################################################"

cd AST

lex AST.l

yacc -d AST.y 

gcc -g y.tab.c lex.yy.c -ll -o AST

./AST

cat AST.txt

rm AST.txt y.tab.c lex.yy.c AST y.tab.h

cd ..

echo "##########################################################################################################################"

g++ generators/code_generator.cpp

./a.out

rm a.out
