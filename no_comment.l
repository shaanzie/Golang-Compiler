
%%
\/[\/]+.* ;
"/*"([^*]|\*+[^*/])*\*+"/" ;
%%

int main()
{
	yyin = fopen("input.go","r");
	yyout = fopen("no_comm.txt","w");
	yylex();
	return 0;	
	
}
