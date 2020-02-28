lex parser.l

yacc parser.y -d

cc lex.yy.c y.tab.c -o parse

./parse
# ./parse

rm lex.yy.c y.tab* parse