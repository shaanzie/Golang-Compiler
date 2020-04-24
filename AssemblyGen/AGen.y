%{
	#include <stdio.h>
	#include <string.h>
	void yyerror(const char *);
	#include<stdlib.h>
	#define YYSTYPE char*
	FILE *yyin;
	int yylex();
	extern int line;
	int i;
	int tempc = 1;
	int labelc = 1;
	int stack1[100];
	int stack2[100];
	char switch_stack[100][100];
	int top1 = 0;
	int top2 = 0;
	int stop = 0;
	int forlabel = 3;
	char* newTemp();
	char* newLabel();
	FILE *icg;

%}




%error-verbose


%left '*'
	

%token T_INT T_PACKAGE T_FUNC T_MAIN T_IMPORT T_IDENTIFIER T_PACKAGE_LITERAL T_FMT T_TIME T_MATH T_CHAR T_FLOAT T_OR_OP T_AND_OP T_NE_OP T_LE_OP T_GE_OP T_INC_OP T_DEC_OP T_INTEGER_LITERAL T_FLOAT_LITERAL T_FOR T_RETURN T_ADD_ASSIGN T_SUB_ASSIGN T_AS_OP T_SWITCH T_BREAK T_CASE T_CONTINUE T_DEFAULT T_EQ_OP T_STRING_LITERAL T_IF
%% 

start:
	{fprintf(icg,"start\n");} translation_unit {fprintf(icg,"end\n");}
translation_unit 
	: external_declaration 
	| translation_unit external_declaration
	;
																			

external_declaration
	: T_FUNC T_MAIN '(' ')' compound_statement 
	| declaration 
	| headers 
	;

headers
	: T_PACKAGE T_PACKAGE_LITERAL 
	| T_IMPORT  libraries
	;

libraries
	: T_FMT 
	| T_MATH 
	| T_TIME 
	;

declaration
	: type_specifier ';' 
	| type_specifier init_declarator_list ';'
	;

type_specifier
	: T_CHAR 
	| T_INT  
	| T_FLOAT 
	;



init_declarator_list
	: init_declarator 
	| init_declarator_list ',' init_declarator 
	;

init_declarator
	: declarator T_AS_OP conditional_expression {fprintf(icg,"LDR %s, %s\n",$1,$3);}
	| declarator 
	;

declarator
	: T_IDENTIFIER 
	;

conditional_expression
	: logical_or_expression 
 	| logical_or_expression '?' expression ':' conditional_expression {char x[10];
 																		strcpy(x,newTemp());
 																		strcpy($$,x);
 																		fprintf(icg,"ifFalse t%d goto L%d\n",tempc-2,labelc);
 																		fprintf(icg,"%s := %s\n",x,$3);
 																		fprintf(icg,"Goto L%d\n",labelc+1);
 																		fprintf(icg,"L%d:\n",labelc);
 																		fprintf(icg,"%s := %s\n",x,$5);
 																		fprintf(icg,"L%d:\n",labelc+1);
																		}
 	;

logical_or_expression
 	: logical_and_expression 
 	| logical_or_expression T_OR_OP logical_and_expression {
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"%s := %s || %s\n",x,$1,$3);
 															strcpy($$,x);
 															}
	;

logical_and_expression
 	: equality_expression 
 	| logical_and_expression T_AND_OP equality_expression {
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"%s := %s && %s\n",x,$1,$3);
 															strcpy($$,x);
 														  }
	; 

equality_expression
 	: relational_expression 
 	| equality_expression T_EQ_OP relational_expression {
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"%s := %s == %s\n",x,$1,$3);
 															strcpy($$,x);
 														}
 	| equality_expression T_NE_OP relational_expression {
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"%s := %s != %s\n",x,$1,$3);
 															strcpy($$,x);
 														}
 	;

relational_expression
 	: additive_expression 
 	| relational_expression '<' additive_expression 	{		
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"MOV %s, %s - %s\n",x,$1,$3);
															fprintf(icg,"%d: CMP %s, 0\n", labelc+1, x);
															labelc += 1;
															fprintf(icg,"BLT %d\n", labelc+1);
 															strcpy($$,x);
 														}
 	| relational_expression '>' additive_expression 	{
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"MOV %s, %s - %s\n",x,$1,$3);
															 fprintf(icg,"%d: CMP %s, 0\n", labelc+1, x);
															 labelc += 1;
															fprintf(icg,"BGT %d\n", labelc+1);
 															strcpy($$,x);
 														}
 	| relational_expression T_LE_OP additive_expression {	
															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"MOV %s, %s - %s\n",x,$1,$3);
															 fprintf(icg,"%d: CMP %s, 0\n", labelc+1, x);
															 labelc += 1;
															fprintf(icg,"BLE %d\n", labelc+1);
 															strcpy($$,x);
 														}
 	| relational_expression T_GE_OP additive_expression {
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"MOV %s, %s - %s\n",x,$1,$3);
															 fprintf(icg,"%d: CMP %s, 0\n", labelc+1, x);
															 labelc += 1;
															fprintf(icg,"BGE %d\n", labelc+1);
 															strcpy($$,x);
 														}
 	;


additive_expression
 	: multiplicative_expression 
 	| additive_expression '+' multiplicative_expression {
															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"ADD %s, %s, %s\n",x,$1,$3);
 															strcpy($$,x);
 														}
 	| additive_expression '-' multiplicative_expression {
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"SUB %s, %s, %s\n",x,$1,$3);
 															strcpy($$,x);
 														}
 	;

multiplicative_expression
 	: unary_expression 
 	| multiplicative_expression '*' unary_expression {		
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"mult %s, %s, %s\n",x,$1,$3);
 															strcpy($$,x);
 														}
 	| multiplicative_expression '/' unary_expression {
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"div %s, %s, %s\n",x,$1,$3);
 															strcpy($$,x);
 														}
 	| multiplicative_expression '%' unary_expression {
 															char x[10];
 															strcpy(x,newTemp());
 															fprintf(icg,"%s := %s mod %s\n",x,$1,$3);
 															strcpy($$,x);
 														}

unary_expression
 	: postfix_expression 
 	| T_INC_OP unary_expression 
 	| T_DEC_OP unary_expression 
 	;

postfix_expression
 	: primary_expression 
	| postfix_expression T_INC_OP 
 	| postfix_expression T_DEC_OP 
	; 

primary_expression
	: T_IDENTIFIER 		
	| T_INTEGER_LITERAL 
	| T_FLOAT_LITERAL 	
	| T_STRING_LITERAL 
	| '(' expression ')' {strcpy($$,$2);}
	;


statement
 	: compound_statement 
 	| expression_statement 
 	| iteration_statement
	| if_statement 
 	;

compound_statement
: '{' '}' 
| '{' block_item_list '}' 
;

block_item_list
	: block_item 
	| block_item_list block_item
	;
block_item
	: declaration 
	| statement 
	;
expression_statement
 	:  expression 
 	;
iteration_statement
 	: T_FOR '(' expression_statement  ';' expression_statement ';' expression ')' statement {
		 																						fprintf(icg, "B %d\n", forlabel--); 
																							}
	| T_FOR '(' declaration ';' expression_statement ';' expression ')' statement {fprintf(icg, "B %d\n", labelc - 1); }
 	;


if_statement : T_IF '(' expression_statement ')' statement 
	;


expression
	: assignment_expression 
	| expression ',' assignment_expression 
	;

assignment_expression
	: conditional_expression 
	| unary_expression T_AS_OP assignment_expression {fprintf(icg,"LDR %s, %s\n",$1,$3);}
	| unary_expression T_ADD_ASSIGN assignment_expression 
	| unary_expression T_SUB_ASSIGN assignment_expression 
	;
%%

int main()
{
icg = fopen("assembly.txt", "w");
yyin = fopen("parsed_input.go","r");
if(!yyparse()){

	printf("\n-----------------------------------\n");
	printf("Parsing succesful\nCheck assembly.txt for Intermediate Code\n");
	printf("-----------------------------------\n\n");
	}


return 0;

}
void yyerror(const char *msg)
{
 	printf("\n");
  	printf("------\n");
	printf("ERROR\n");
	printf("------\n");
	printf("Parsing Unsuccesful\n");
	printf("Syntax Error at line %d\n\n",line);

}

char* newTemp()
{
	char* x;
	x = (char*)malloc(sizeof(char)*20);
	strcpy(x,"t");
	char j[20];
	snprintf(j,20*sizeof(char),"%d",tempc);
	strcat(x,j);
	tempc++;
	return x;
}

