%{
    #include<stdio.h>
    int valid = 0;
%}

%token FOR
%token IF ELSE
%token NUM ID FUNC
%token Forstmt Ifstmt

%right ASOP
%left AND OR
%left '<' '>' LE GE EQ NE LT GT

%% 
start: Function 
    | Declaration
    ;

Declaration: Assignment
;
Assignment: ID ASOP Assignment ;
Function: FUNC ID '(' ')' CompoundStmt 
;
CompoundStmt: '{' StmtList '}'
;
StmtList: StmtList Stmt
    |
    ;
ForStmt: FOR '(' Expr ';' Expr ';' Expr ')' Stmt
       | FOR '(' Expr ')' CompoundStmt
    ;
IfStmt: IF '(' Expr ')' CompoundStmt
    ;
Stmt: Declaration
    |Forstmt
    |Ifstmt
    |Assignment
    ;

Expr:
    | Expr LE Expr
    | Expr GE Expr
    | Expr NE Expr
    | Expr EQ Expr
    | Expr GT Expr
    | Expr LT Expr
    | Assignment
    ;
%%
#include"lex.yy.c"
#include<ctype.h>
int count=0;

int main(int argc, char *argv[])
{
    yyin = fopen(argv[1], "r");

    if(!yyparse())
        printf("\nParsing complete\n");
    else
        printf("\nParsing failed\n");

    fclose(yyin);
    return 0;
}

yyerror(char *s) {
    printf("%d : %s %s\n", yylineno, s, yytext );
}