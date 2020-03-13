digit [0-9]
letter [A-Za-z]

%{
 #include "y.tab.h"
 extern int yylval;
%}
%option yylineno
%%
"return"												return RETURN;
"if" 													return IF;
"else" 													return ELSE;
"for"													return FOR;					
":="													return ASOP;
">=" | "<=" | "=="										return RELOP;
"func"													return FUNC;
{letter}({letter}|{digit})* 							return ID;
{digit}+												return NUM;
"\n"													return 0;
(.)														return yytext[0];
^"package".+ 											return PACKAGE;						
^"import".+												return IMPORT;
%%

int yywrap()
{
	return 1;
}
