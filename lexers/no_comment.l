
%%
\/[\/]+.* ;
"/*"([^*]|\*+[^*/])*\*+"/" ;
%%

int main()
{
	yyin = fopen("input.go","r");
	yyout = fopen("no_comm.go","w");
	yylex();
	fclose(yyin);
	fclose(yyout);
	return 0;	
	
}
