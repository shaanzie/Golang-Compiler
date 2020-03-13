%{
#include<bits/stdc++.h>

using namespace std;

extern "C";
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

program: stmts {$$ = create_body($1);}
;

stmts:var_decl 
    |for_stmt 
    |if_stmt 
    |'{'
    |'}'
    ;
for_stmt: FOR '('cond_for')' '{' stmts '}' {$$ = create_for_node($1, $2, $3)}
;
cond_for: ID '-' NUM ';'  {$$=create_relfor_node($1,'-',$2);}
    |ID '<' NUM ';'  {$$=create_relfor_node($1,'<',$2);}
    |ID '>' NUM ';' {$$=create_relfor_node($1,'>',$2);}
    |ID "<=" NUM ';'{$$=create_relfor_node($1,"<=",$2);}
    |ID ">=" NUM ';'{$$=create_relfor_node($1,">=",$2);}
    |ID "++"      {$$=create_relfor_node($1);}
    |ID "--"      {$$=create_relfor_node($1);}
;

if_stmt: IF '('cond_if ')' '{' stmts '}' ;

cond_if: ID '<' NUM ';'  {$$=create_bin_node($1,'<',$2);}
    |ID '>' NUM ';'      {$$=create_bin_node($1,'>',$2);}
    |ID "==" NUM         {$$=create_bin_node($1,"==",$2);}
    |ID "<=" NUM ';'{$$=create_bin_node($1,"<=",$2);}
    |ID ">=" NUM ';'{$$=create_bin_node($1,">=",$2);}
;

var_decl: ID ASOP NUM  {$$=create_as_node($1,$2,$3);}
;



%%
#include<ctype.h>

typedef struct fornode {

    string for_key;
    struct condnode* condition;
    struct container* statement;

}fornode;

typedef struct condnode {
    string left;
    string right;
    string op;
}condnode;

typedef struct container{
    string type;
    int level;
    node* children[100];
}Container;

Container* head = (Container*)malloc(sizeof(Container));

void create_body(string text)
{
    head->type = text;
}

void create_for_node(string for_key, string cond, string statement) {

    fornode* newfor = (fornode*)malloc(sizeof(fornode));
    condnode* condition = (condnode*)malloc(sizeof(condnode));
    container* newcont = (container*)malloc(sizeof(container));
    
    newfor->for_key = for_key;
    newfor->condition = condition;
    newfor->statement = newcont;
    

}


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