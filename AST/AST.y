%{
	#include <stdio.h>
	#include <string.h>
	#include "header.c"
	void yyerror(const char *);
	#include<stdlib.h>
	#define YYSTYPE YACC
	FILE *yyin;
	int yylex();
	AST* ast;
	TREE* nptr = NULL;

	TREE* newnode(char*,TREE*,TREE*,TREE*,TREE*);
	TREE* newleaf(char*,char*);
	void display(TREE*);
	void printBT(char*,TREE*,int);
	FILE *fp;
	extern int line;

%}



%error-verbose


%left '*'
	

%token T_INT T_PACKAGE T_FUNC T_MAIN T_IMPORT T_IDENTIFIER T_PACKAGE_LITERAL T_FMT T_TIME T_MATH T_CHAR T_FLOAT T_OR_OP T_AND_OP T_NE_OP T_LE_OP T_GE_OP T_INC_OP T_DEC_OP T_INTEGER_LITERAL T_FLOAT_LITERAL T_FOR T_RETURN T_ADD_ASSIGN T_SUB_ASSIGN T_AS_OP T_SWITCH T_BREAK T_CASE T_CONTINUE T_DEFAULT T_EQ_OP T_STRING_LITERAL T_IF
%% 
translation_unit 
	: external_declaration {
								$$.ptr = $1.ptr;
								ast->root = $$.ptr;

								
							}
	| translation_unit external_declaration {	
												$$.ptr = newnode("SEQ",$1.ptr,$2.ptr,nptr,nptr);
												ast->root  = $$.ptr;
											}
	;

external_declaration
	: T_FUNC T_MAIN '(' ')' compound_statement {$$.ptr = $5.ptr;}
	| declaration  {$$.ptr = $1.ptr;}
	| headers  {$$.ptr = $1.ptr;}
	;

headers
	: T_PACKAGE T_PACKAGE_LITERAL {$$.ptr = newleaf("PACKAGE",$2.val);}
	| T_IMPORT  libraries  {$$.ptr = $2.ptr;}
	;

libraries
	: T_FMT {$$.ptr = newleaf("fmt","N/A");}
	| T_MATH {$$.ptr = newleaf("math","N/A");}
	| T_TIME {$$.ptr = newleaf("time","N/A");}
	;

declaration
	: type_specifier ';' {$$.ptr = newnode("DECL",$1.ptr,nptr,nptr,nptr);}
	| type_specifier init_declarator_list ';' {$$.ptr = newnode("DECL",$1.ptr,$2.ptr,nptr,nptr);}
	;

type_specifier
	: T_CHAR {$$.ptr = newleaf("keyword","char");}
	| T_INT  {$$.ptr = newleaf("keyword","int");}
	| T_FLOAT {$$.ptr = newleaf("keyword","float");}
	;



init_declarator_list
	: init_declarator {$$.ptr = $1.ptr;}
	| init_declarator_list ',' init_declarator {$$.ptr = newnode(",",$1.ptr,$3.ptr,nptr,nptr);}
	;

init_declarator
	: declarator T_AS_OP conditional_expression {$$.ptr = newnode(":=",$1.ptr,$3.ptr,nptr,nptr);}
	| declarator {$$.ptr = $1.ptr;}
	;

declarator
	: T_IDENTIFIER {$$.ptr = newleaf("id",$1.val);}
	;

conditional_expression
	: logical_or_expression {$$.ptr = $1.ptr;}
 	| logical_or_expression '?' expression ':' conditional_expression {$$.ptr = newnode("TERNARY",$1.ptr,$3.ptr,$5.ptr,nptr);}
 	;

logical_or_expression
 	: logical_and_expression {$$.ptr = $1.ptr;}
 	| logical_or_expression T_OR_OP logical_and_expression {$$.ptr = newnode("||",$1.ptr,$3.ptr,nptr,nptr);}
	;

logical_and_expression
 	: equality_expression {$$.ptr = $1.ptr;}
 	| logical_and_expression T_AND_OP equality_expression {$$.ptr = newnode("&&",$1.ptr,$3.ptr,nptr,nptr);}
	; 

equality_expression
 	: relational_expression {$$.ptr = $1.ptr;}
 	| equality_expression T_EQ_OP relational_expression {$$.ptr = newnode("==",$1.ptr,$3.ptr,nptr,nptr);}
 	| equality_expression T_NE_OP relational_expression {$$.ptr = newnode("!=",$1.ptr,$3.ptr,nptr,nptr);}
 	;

relational_expression
 	: additive_expression {$$.ptr = $1.ptr;}
 	| relational_expression '<' additive_expression {$$.ptr = newnode("<",$1.ptr,$3.ptr,nptr,nptr);}
 	| relational_expression '>' additive_expression {$$.ptr = newnode(">",$1.ptr,$3.ptr,nptr,nptr);}
 	| relational_expression T_LE_OP additive_expression {$$.ptr = newnode("<=",$1.ptr,$3.ptr,nptr,nptr);}
 	| relational_expression T_GE_OP additive_expression {$$.ptr = newnode(">=",$1.ptr,$3.ptr,nptr,nptr);}
 	;


additive_expression
 	: multiplicative_expression {$$.ptr = $1.ptr;}
 	| additive_expression '+' multiplicative_expression {$$.ptr = newnode("+",$1.ptr,$3.ptr,nptr,nptr);}
 	| additive_expression '-' multiplicative_expression {$$.ptr = newnode("-",$1.ptr,$3.ptr,nptr,nptr);}
 	;

multiplicative_expression
 	: unary_expression {$$.ptr = $1.ptr;}
 	| multiplicative_expression '*' unary_expression {$$.ptr = newnode("*",$1.ptr,$3.ptr,nptr,nptr);}
 	| multiplicative_expression '/' unary_expression {$$.ptr = newnode("/",$1.ptr,$3.ptr,nptr,nptr);}
 	| multiplicative_expression '%' unary_expression {$$.ptr = newnode("%",$1.ptr,$3.ptr,nptr,nptr);}
 	;

unary_expression
 	: postfix_expression {$$.ptr = $1.ptr;}
 	| T_INC_OP unary_expression {$$.ptr = newnode("++",$1.ptr,nptr,nptr,nptr);}
 	| T_DEC_OP unary_expression {$$.ptr = newnode("--",$1.ptr,nptr,nptr,nptr);}
 	;

postfix_expression
 	: primary_expression {$$.ptr = $1.ptr;}
	| postfix_expression T_INC_OP {$$.ptr = newnode("++",$1.ptr,nptr,nptr,nptr);}
 	| postfix_expression T_DEC_OP {$$.ptr = newnode("--",$1.ptr,nptr,nptr,nptr);}
	; 

primary_expression
	: T_IDENTIFIER 		{$$.ptr = newleaf("id",$1.val);}
	| T_INTEGER_LITERAL {$$.ptr = newleaf("num",$1.val);}
	| T_FLOAT_LITERAL 	{$$.ptr = newleaf("num",$1.val);}
	| T_STRING_LITERAL 	{$$.ptr = newleaf("string",$1.val);}
	| '(' expression ')' {$$.ptr = $2.ptr;}
	;


statement
 	: compound_statement {$$.ptr = $1.ptr;}
 	| expression_statement {$$.ptr = $1.ptr;}
 	| iteration_statement {$$.ptr = $1.ptr;}
	| if_statement {$$.ptr = $1.ptr;}
 	;

compound_statement
: '{' '}' {$$.ptr = newleaf("{ }","N/A");}
| '{' block_item_list '}' {$$.ptr = $2.ptr;}
;

block_item_list
	: block_item {$$.ptr = $1.ptr;}
	| block_item_list block_item {$$.ptr = newnode("SEQ",$1.ptr,$2.ptr,nptr,nptr);}
	;
block_item
	: declaration {$$.ptr = $1.ptr;}
	| statement {$$.ptr = $1.ptr;}
	;
expression_statement
 	:  expression {$$.ptr = $1.ptr;}
 	;
iteration_statement
 	: T_FOR '(' expression_statement ';' expression_statement ')' statement {$$.ptr = newnode("FOR",$3.ptr,$5.ptr,$7.ptr,nptr);}
	| T_FOR '(' expression_statement ';' expression_statement ';' expression ')' statement  {$$.ptr = newnode("FOR",$3.ptr,$5.ptr,$7.ptr,$9.ptr);}
	| T_FOR '(' declaration ';' expression_statement ')' statement  {$$.ptr = newnode("FOR",$3.ptr,$5.ptr,$7.ptr,nptr);}
	| T_FOR '(' declaration ';' expression_statement ';' expression ')' statement  {$$.ptr = newnode("FOR",$3.ptr,$5.ptr,$7.ptr,$9.ptr);}
 	;

if_statement : T_IF '(' expression_statement ')' statement {$$.ptr = newnode("IF",$3.ptr,$5.ptr,nptr,nptr);}
	;


expression
	: assignment_expression {$$.ptr = $1.ptr;}
	| expression ',' assignment_expression {$$.ptr = newnode(",",$1.ptr,$3.ptr,nptr,nptr);}
	;

assignment_expression
	: conditional_expression {$$.ptr = $1.ptr;}
	| unary_expression T_AS_OP assignment_expression {$$.ptr = newnode(":=",$1.ptr,$3.ptr,nptr,nptr);}
	| unary_expression T_ADD_ASSIGN assignment_expression {$$.ptr = newnode("+=",$1.ptr,$3.ptr,nptr,nptr);} 
	| unary_expression T_SUB_ASSIGN assignment_expression {$$.ptr = newnode("-=",$1.ptr,$3.ptr,nptr,nptr);}
	;
%%

int main()
{
	fp = fopen("AST.txt", "w");
	ast = (AST*)malloc(sizeof(AST));
	ast->root = NULL;

yyin = fopen("../parsed_input.go","r");
if(!yyparse()){
	
	printf("\n--------------------------------------");
	printf("\nParsing succesful\nCheck AST.txt for Abstract Syntax Tree\n");
	printf("--------------------------------------\n\n");

	fprintf(fp,"\n\n-------------------\n");
	fprintf(fp,"Abstract Syntax Tree\n");
	fprintf(fp,"-------------------\n\n");
	//display(ast->root);
	
	printBT("",ast->root,0);
	fprintf(fp,"\n");
	fclose(fp);
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


TREE* newnode(char* o,TREE* cc1,TREE* cc2,TREE* cc3, TREE* cc4)
{
	TREE* temp = (TREE*)malloc(sizeof(TREE));
	strcpy(temp->opr,o);
	strcpy(temp->value,"N/A");
	temp->c1 = cc1;
	temp->c2 = cc2;
	temp->c3 = cc3;
	temp->c4 = cc4;

	return temp;
}

TREE* newleaf(char* o, char* v)
{
	TREE* temp = (TREE*)malloc(sizeof(TREE));
	strcpy(temp->opr,o);
	strcpy(temp->value,v);
	temp->c1 = NULL;
	temp->c2 = NULL;
	temp->c3 = NULL;
	temp->c4 = NULL;

	return temp;
}

void display(TREE* r)
{	
	
	if(r==NULL)
		return;
	if(r->c1==NULL && r->c2==NULL && r->c3==NULL)
	{
		printf("(");
		printf("%s\t%s)\n",r->opr,r->value);
	}
	else
		printf("%s\n",r->opr);
	display(r->c1);
	display(r->c2);
	display(r->c3);
	display(r->c4);
}


void printBT(char* prefix, TREE* node, int isLeft)
{	
	
	if(node==NULL)
		return;
    if( node != NULL)
    {
       fprintf(fp,"%s",prefix);

       	if(isLeft==0)
       		fprintf(fp,"└──");
       	else
       		fprintf(fp,"├──");
 
        // print the value of the node

     if(node->c1==NULL && node->c2==NULL && node->c3==NULL && node->c4==NULL)
	{
		
		fprintf(fp,"(%s, %s)\n",node->opr,node->value);
	}
	else
		fprintf(fp,"%s\n",node->opr);
        // enter the next tree level - left and right branch
        char new_prefix[1000];
       	if(isLeft==0){
       		strcpy(new_prefix,prefix);
       		strcat(new_prefix,"    ");
       	}
       	else
       		{
       		strcpy(new_prefix,prefix);
       		strcat(new_prefix,"│   ");
       	}


     if(node->c1!=NULL && node->c2==NULL && node->c3==NULL && node->c4==NULL)
	{
		printBT(new_prefix, node->c1, 0);
        printBT(new_prefix, node->c2, 0);
        printBT(new_prefix, node->c3, 0);
        printBT(new_prefix, node->c4, 0);
        return;
	}
	if(node->c1!=NULL && node->c2!=NULL && node->c3==NULL && node->c4==NULL)
	{
		printBT(new_prefix, node->c1, 1);
        printBT(new_prefix, node->c2, 0);
        printBT(new_prefix, node->c3, 0);
        printBT(new_prefix, node->c4, 0);
        return;
	}
	if(node->c1!=NULL && node->c2!=NULL && node->c3!=NULL && node->c4==NULL)
	{
		printBT(new_prefix, node->c1, 1);
        printBT(new_prefix, node->c2, 1);
        printBT(new_prefix, node->c3, 0);
        printBT(new_prefix, node->c4, 0);
        return;
	}	
	if(node->c1!=NULL && node->c2!=NULL && node->c3!=NULL && node->c4!=NULL)
	{
		printBT(new_prefix, node->c1, 1);
        printBT(new_prefix, node->c2, 1);
        printBT(new_prefix, node->c3, 1);
        printBT(new_prefix, node->c4, 0);
        return;
	}	
        
    }
    	
}

