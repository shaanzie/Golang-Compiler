digit [0-9]
letter [A-Za-z]
%option yylineno
%option noyywrap

%{
#include<iostream>
#include<string>
#include<cstdio>
int scope = 0;

using namespace std;
void token_type(string s);
void set_ID(string s,string type);
void set_uninitialise(string s,string type);
%}

%%
\{													{scope++;}
\}													{scope--;}
"var "{letter}({letter}|{digit})*" int"				{set_uninitialise(yytext,"int");}
"var "{letter}({letter}|{digit})*" float"			{set_uninitialise(yytext,"float");}
"var "{letter}({letter}|{digit})*" string"			{set_uninitialise(yytext,"string");}
{letter}({letter}|{digit})*\:\=\{({digit}\,?)*\} 	{set_ID(yytext,"array");}
{letter}({letter}|{digit})*\:\=({digit}*) 			{set_ID(yytext,"int");}
{letter}({letter}|{digit})*\:\=(\"(.)*\") 			{set_ID(yytext,"string");}
{letter}({letter}|{digit})*\:\=({digit}*\.{digit}*) {set_ID(yytext,"float");}
{letter}({letter}|{digit})*\:\=("true"|"false")		{set_ID(yytext,"boolean");} 
"package"|"import"|"func"|"if"|"else"|"break"|"var"	{;}
"\"fmt\""|"main" 									{;}
{letter}({letter}|{digit})* 						{;}
.|"main()" 								     		{;}
"\n" 												{}
%%

int main()
{
	extern FILE *yyin,*yyout;
	yyin=fopen("input.go","r");
	yyout=fopen("identifiers.txt","w");
	yylex();
	return 0;	
}

void set_ID(string s,string type)
{
	int i = 0;
	size_t pos = 0;
	string token;
	string delimiter = ":=";
	while ((pos = s.find(delimiter)) != string::npos) {
    	token = s.substr(0, pos);
    	s.erase(0, pos + delimiter.length());
	}
	fprintf(yyout,"%s,%s,%d,%d,%s\n",token.c_str(),type.c_str(),scope,yylineno,s.c_str());
	//cout << "identifier: "<<token<< " type: "<<type<<" value: "<<s<<" scope: "<<scope<<" line no: "<<yylineno<<endl;
}

void set_uninitialise(string s,string type)
{
	int i = 0;
	size_t pos = 0;
	string token;
	string delimiter = " ";
	while ((pos = s.find(delimiter)) != string::npos) {
    	token = s.substr(0, pos);
    	s.erase(0, pos + delimiter.length());
	}
	if (type.compare("string")==0)
	{
		fprintf(yyout,"%s,%s,%d,%d,%s\n",token.c_str(),type.c_str(),scope,yylineno,"\"\"");
	}
	else
		fprintf(yyout,"%s,%s,%d,%d,%s\n",token.c_str(),type.c_str(),scope,yylineno,"0");

}


