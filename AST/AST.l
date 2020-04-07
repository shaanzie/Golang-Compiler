%{
	#include "header.c"
	#define YYSTYPE YACC
	#include "y.tab.h"
    #include <stdio.h>
    extern void yyerror(const char *);
    int line = 1;

%}

D   		[0-9]
E			[Ee][+-]?{D}+
L   		[a-zA-Z_]
A   		[a-zA-Z_0-9]
WS  		[ \t\v\f]

%%

[\n]				{line++;}
"func"				{yylval.val = strdup(yytext);return T_FUNC;} 
"package"			{yylval.val = strdup(yytext);return T_PACKAGE;}	
"main"				{yylval.val = strdup(yytext);return T_MAIN;}
"import"			{yylval.val = strdup(yytext);return T_IMPORT;} 
"int"				{yylval.val = strdup(yytext);return T_INT;} 
"char"				{yylval.val = strdup(yytext);return T_CHAR;} 
"float"				{yylval.val = strdup(yytext);return T_FLOAT;}
"for"				{yylval.val = strdup(yytext);return T_FOR;} 
"if"				{yylval.val = strdup(yytext);return T_IF;}
"return"			{yylval.val = strdup(yytext);return T_RETURN;}
"Compiler"			{yylval.val = strdup(yytext);return T_PACKAGE_LITERAL;}

 
"||"				{return T_OR_OP;} 
"&&"				{return T_AND_OP;} 
"=="				{return T_EQ_OP;} 
"!="				{return T_NE_OP;} 
"<="				{return T_LE_OP;} 
">="				{return T_GE_OP;} 
"++"				{return T_INC_OP;} 
"--"				{return T_DEC_OP;}
"+="				{return T_ADD_ASSIGN;} 
"-="				{return T_SUB_ASSIGN;}
":="				{return T_AS_OP;}


"\"fmt\""				{return T_FMT;} 
"\"time\"" 				{return T_TIME;} 
"\"math\""				{return T_MATH;} 

{L}{A}*				{yylval.val = strdup(yytext);return T_IDENTIFIER;}




	
";"			{return (';');}
"{"			{return('{'); }
"}"			{return('}'); }
","			{return(','); }
":"			{return(':'); }
"="			{return('='); }
"("			{return('('); }
")"			{return(')'); }
"["			{return('['); }
"]"			{return(']'); }
"-"			{return('-'); }
"+"			{return('+'); }
"*"			{return('*'); }
"/"			{return('/'); }
"%"			{return('%'); }
"<"			{return('<'); }
">"			{return('>'); }
"^"			{return('^'); }
"|"			{return('|'); }
"?"			{return('?'); }



{D}+			{yylval.val = strdup(yytext);return T_INTEGER_LITERAL;} 
{D}+\.{D}+		{yylval.val = strdup(yytext);return T_FLOAT_LITERAL;} 
\"(\\.|[^\\"])*\"	{yylval.val = strdup(yytext);return T_STRING_LITERAL;} 


\/\/[^\n]*			{}
"/*"([^*]|\*+[^*/])*\*+"/" 	{};	

{WS}+				{}

.					{ printf("No Match, Invalid Expression %s\n", yytext); }

%%
