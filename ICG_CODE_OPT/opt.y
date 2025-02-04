%{
	#include <stdio.h>
	#include <string.h>
	#include<stdlib.h>
	void yyerror(const char *);
	#define YYSTYPE char*
	FILE *yyin;
	int yylex();
	extern int line;
	FILE *opt;

	typedef struct symbol_table_node
	{
		char name[30];
		char value[30];
	}NODE;

	NODE table[100];
	int top = -1;
	void add_or_update(char*,char*);
	char* getVal(char*);
	char* calculate(char*,char*,char*);
%}

%error-verbose

%token T_START T_END T_IDENTIFIER T_NUMBER T_GOTO T_IFFALSE T_LE_OP T_GE_OP T_MOD_OP T_EQ_OP T_NE_OP T_OR_OP T_AND_OP T_AS_OP


%%
supreme_start
	:start supreme_start
	|start
	;

start
	:T_IDENTIFIER T_AS_OP T_NUMBER  {
									add_or_update($1,$3);
									fprintf(opt,"%s := %s\n",$1,$3);
								}
	|T_IDENTIFIER T_AS_OP T_IDENTIFIER {
										add_or_update($1,getVal($3));
										fprintf(opt,"%s := %s\n",$1,getVal($3));	

									}
	|T_IDENTIFIER T_AS_OP T_IDENTIFIER opr T_IDENTIFIER {
														add_or_update($1,calculate($4,getVal($3),getVal($5)));
														fprintf(opt,"%s := %s\n",$1,calculate($4,getVal($3),getVal($5)));

													}
	|T_IDENTIFIER T_AS_OP T_NUMBER opr T_IDENTIFIER		{
														add_or_update($1,calculate($4,$3,getVal($5)));
														fprintf(opt,"%s := %s\n",$1,calculate($4,$3,getVal($5)));

													}
	|T_IDENTIFIER T_AS_OP T_IDENTIFIER opr T_NUMBER		{
														add_or_update($1,calculate($4,getVal($3),$5));
														fprintf(opt,"%s := %s\n",$1,calculate($4,getVal($3),$5));

													}
	|T_IDENTIFIER T_AS_OP T_NUMBER opr T_NUMBER			{	
														
														add_or_update($1,calculate($4,$3,$5));
														fprintf(opt,"%s := %s\n",$1,calculate($4,$3,$5));

													}
	|T_GOTO T_IDENTIFIER {fprintf(opt,"%s %s\n",$1,$2);}
	|T_GOTO T_END {fprintf(opt,"%s %s\n",$1,$2);}
	|T_IFFALSE T_IDENTIFIER T_GOTO T_IDENTIFIER {fprintf(opt,"%s %s %s %s\n",$1,$2,$3,$4);}
	|T_IDENTIFIER':' {fprintf(opt,"%s:\n",$1);}
	|T_START {fprintf(opt,"%s\n",$1);}
	|T_END   {fprintf(opt,"%s\n",$1);}
	;

opr
	:'+' 
	|'-'
	|'*'
	|'/'
	|'<'
	|'>'
	|T_LE_OP 
	|T_GE_OP
	|T_MOD_OP
	|T_EQ_OP
	|T_NE_OP
	|T_OR_OP
	|T_AND_OP
	;
%%

int main()
{
opt = fopen("Optimize.txt", "w");
if(opt==NULL)
{	
	printf("\n-----------------------------------\n");
	printf("Please first create the Intermediate Code\n");
	printf("-----------------------------------\n\n");
}
yyin = fopen("icg.txt","r");
if(!yyparse())
{	printf("\n-----------------------------------\n");
	printf("Intermediate Code Optimized\nPlease check Optimize.txt for the Optimized IC\n");
	printf("-----------------------------------\n\n");
}

return 1;
}

void yyerror(const char *msg)
{

	printf("\n");
  	printf("------\n");
	printf("ERROR\n");
	printf("------\n");
	printf("Parsing Unsuccesful\n");
	printf("Syntax Error at line %d\n\n",line-1);

}

void add_or_update(char* name,char* value)
{
	if(top==-1)
	{
		
		top++;
		strcpy(table[top].name,name);
		strcpy(table[top].value,value);
		return;
	}
	for(int i = top;i>=0;i--)
	{
		if(strcmp(table[i].name,name)==0)
		{
			strcpy(table[i].value,value);
			return;
		}
	}
	
	top++;
	
	strcpy(table[top].name,name);
	
	strcpy(table[top].value,value);



}
char* getVal(char* name)
{
	for(int i = top;i>=0;i--)
	{
		if(strcmp(table[i].name,name)==0)
		{
			return table[i].value;
		}
	}
	return "a";
}
char* calculate(char* opr,char* op1,char* op2)
{	
	char* result;
	result = (char*)malloc(sizeof(char)*30);
	int oper1 = atoi(op1);
	int oper2 = atoi(op2);
	int res;
	if(strcmp(opr,"+")==0)
		res = oper1 + oper2;
	if(strcmp(opr,"-")==0)
		res = oper1 - oper2;		
	if(strcmp(opr,"*")==0)
		res = oper1 * oper2;
	if(strcmp(opr,"/")==0)
		res = oper1 / oper2;
	if(strcmp(opr,">")==0)
		res = oper1 > oper2;
	if(strcmp(opr,"<")==0)
		res = oper1 < oper2;
	if(strcmp(opr,">=")==0)
		res = oper1 >= oper2;
	if(strcmp(opr,"<=")==0)
		res = oper1 <= oper2;
	if(strcmp(opr,"mod")==0)
		res = oper1 % oper2;
	if(strcmp(opr,"==")==0)
		res = oper1 == oper2;
	if(strcmp(opr,"!=")==0)
		res = oper1 != oper2;
	if(strcmp(opr,"&&")==0)
		res = oper1 && oper2;
	if(strcmp(opr,"||")==0)
		res = oper1 || oper2;


	snprintf(result,30*sizeof(char),"%d",res);
	return result;
}
