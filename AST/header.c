typedef struct tree
{
	char opr[100];
	char value[100];
	struct tree* c1;
	struct tree* c2;
	struct tree* c3;
	struct tree* c4;
}TREE;

typedef struct ast
{
	TREE* root;
}AST;

typedef struct yacc
{
	char* val;
	TREE* ptr;

}YACC;