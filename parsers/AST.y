%{
#include<string>
extern int yylineno;
extern char* yytext;
using namespace std;

typedef struct statement{
    string type;
    string parent;
    int no_child; 
}Statement;

typedef struct BinStatement{
    string type;
    string parent;
    string left_child;
    string right_child;
}BinStatement;

void create_node(string type);
void create_bin_node(string left,char op,string right);

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

program: stmts {$$=create_body($1);}
;

stmts:var_decl {$$=create_node($1);}
    |for_stmt {$$=create_node($1);}
    |if_stmt {$$=create_node($1);}
    |'{'
    |'}'
    ;
for_stmt: FOR '('cond_for')' '{' stmts '}'
;
cond_for: ID '-' NUM ';'  {$$=create_bin_node($1,'-',$2);}
    |ID '<' NUM ';'  {$$=create_bin_node($1,'<',$2);}
    |ID '>' NUM ';' {$$=create_bin_node($1,'>',$2);}
    |ID "<=" NUM ';'{$$=create_bin_node($1,"<=",$2);}
    |ID ">=" NUM ';'{$$=create_bin_node($1,">=",$2);}
    |ID "++"      {$$=create_bin_node($1);}
    |ID "--"      {$$=create_bin_node($1);}
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
void create_node(string type)
{
    Statement node = new Statement();
    node.type = type;
    node.no_child += 1;
}

void create_bin_node(string left,char op,string right)
{
    BinStatement node = new BinStatement();
    node.parent = op;
    node.left = left;
    node.right = right;
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