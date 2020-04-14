%{
	#define YYSTYPE char*
	#include "y.tab.h"
    #include <stdio.h>
    extern void yyerror(const char *);
    int line = 1;
%}

D   		[0-9]
L   		[a-zA-Z_]
A   		[a-zA-Z_0-9]
WS  		[  \t\v\f]

%%

[\n]				{line++;}
"||"				{yylval = strdup(yytext);return T_OR_OP;} 
"&&"				{yylval = strdup(yytext);return T_AND_OP;} 
"=="				{yylval = strdup(yytext);return T_EQ_OP;} 
"!="				{yylval = strdup(yytext);return T_NE_OP;} 
"<="				{yylval = strdup(yytext);return T_LE_OP;} 
">="				{yylval = strdup(yytext);return T_GE_OP;} 
"mod"				{yylval = strdup(yytext);return T_MOD_OP;}
":="				{yylval = strdup(yytext);return T_AS_OP;}	


":"					{yylval = strdup(yytext);return(':'); }
"-"					{yylval = strdup(yytext);return('-'); }
"+"					{yylval = strdup(yytext);return('+'); }
"*"					{yylval = strdup(yytext);return('*'); }
"/"					{yylval = strdup(yytext);return('/'); }
"<"					{yylval = strdup(yytext);return('<'); }
">"					{yylval = strdup(yytext);return('>'); }
"="					{yylval = strdup(yytext);return('='); }

"Goto"				{yylval = strdup(yytext);return T_GOTO;}
"ifFalse"			{yylval = strdup(yytext);return T_IFFALSE;}
"start"				{yylval = strdup(yytext);return T_START;}
"end"				{yylval = strdup(yytext);return T_END;}

{D}+|{D}+.{D}+		{yylval = strdup(yytext);return T_NUMBER;} 
{L}{A}*				{yylval = strdup(yytext);return T_IDENTIFIER;}




{WS}+				{}

.					{ printf("No Match, Invalid Expression %s\n", yytext); }






%%
