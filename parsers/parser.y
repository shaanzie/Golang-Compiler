%{
    #include<stdio.h>
    // #include "lex.yy.c"
    int valid = 0;
    extern int yylineno;
    extern char* yytext;
%}

%token FOR
%token IF 
%token ELSE
%token NUM 
%token ID 
%token FUNC
%token PACKAGE
%token IMPORT

%token ASOP
%token RELOP
%token RETURN

%right ASOP
%left RELOP

%% 
Start:  Assign      {printf("Assign");}
    |   Forstmt     {printf("For");}
    |   Ifstmt      {printf("If");}
    |   '{'
    |   '}'
    |   RETURN
    |   PACKAGE
    |   IMPORT 
    |   Rel         {printf("Rel");}
;

Forstmt:    FOR '(' ID Rel NUM ';' ID Rel NUM ';' ID Rel ')' Stmt
;

Ifstmt: IF '('  ID Rel NUM ')' Stmt
;

Assign:   ID ASOP NUM  {printf("Assign");}
;

Rel:    RELOP   {printf("Rel");}
    |   Rel Rel
    |   '+'
    |   '-'
    |   '*'
    |   '/'
    |   '>'
    |   '<'
    |   '='
;


Stmt: 
;

%%
// #include"lex.yy.c"
#include<ctype.h>
int count=0;

int main(int argc, char *argv[])
{
    // yyin = fopen(argv[1], "r");


    if(!yyparse())
        printf("\nParsing complete\n");
    else
        printf("\nParsing failed\n");

    // fclose(yyin);
    // printf("Sup");
    // yyparse();
    return 1;
}


yyerror(char *s) {
    printf("%d : %s %s\n", yylineno, s, yytext );
    // printf("ERROR");
}