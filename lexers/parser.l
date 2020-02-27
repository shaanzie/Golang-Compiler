digit [0-9]
letter [A-Za-z]

%{
 #include "y.tab.h"
%}
%option yylineno
%%
"if"						return IF;
"else"						return ELSE;
"for"						return FOR;
"&&"						return AND;
"||"						return OR;
"<="    					return LE;
">="    					return GE;
"=="    					return EQ;
"!="    					return NE;
">" 						return GT;
"<" 						return LT;
":="						return ASOP;
"func"						return FUNC;
{letter}({letter}|{digit})* return ID;
{digit}+					return NUM;
"\n"						return 0;
(.)							return yytext[0];
^"package compiler".+ 		;						
^"import \"fmt\""			;
%%

int yywrap()
{
	return 1;
}
