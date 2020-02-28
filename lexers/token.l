digit [0-9]
letter [A-Za-z]
%option yylineno

%{
#include<bits/stdc++.h>

using namespace std;
void set_token(string s, string token);
void error();
%}

%%
"package"|"import"|"func"|"if"|"else"|"break"|"var"|"for"|"return"	{set_token(yytext,"Keyword");}
"\"fmt\""|"main"|"return"											{set_token(yytext,"Package");}
{letter}({letter}|{digit})* 								{set_token(yytext,"Identifier");}
\{															{set_token(yytext,"LBrace");}
\}															{set_token(yytext,"RBrace");}
\[															{set_token(yytext,"LBrack");}
\]															{set_token(yytext,"RBrack");}
\(															{set_token(yytext,"LParen");}
\)															{set_token(yytext,"RParen");}
"+"|"-"|"*"|"/"|"%"|"++"|"--"								{set_token(yytext,"Arithmetic Operator");}
"=="|"!="|">"|"<"|">="|"<="									{set_token(yytext,"Relational operator");}
"&&"|"||"|"!"												{set_token(yytext,"Logical operator");}
"&"|"|"|"^"													{set_token(yytext,"Bitwise Operator");}
"="|"+="|"*="|"/="|"%="|"<<="|">>="|"&="|"^="|"|="			{set_token(yytext,"Assignment operators");}
"\n"														{}
(.)															{error();}

%%
int main()
{
	extern FILE *yyin,*yyout;
	yyin=fopen("input.go","r");
	yyout=fopen("tokens.txt","w");
	yylex();
	return 0;	
}

void set_token(string s,string token)
{
	fprintf(yyout,"Token:%s Type:%s Line No:%d\n",yytext,token.c_str(),yylineno);
}

void error()
{
	FILE *fp;
	fp=fopen("error.txt","w");
	fprintf(fp,"input.go:%d:error",yylineno);
	fclose(fp);
}
