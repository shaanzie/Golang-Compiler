%% 
[ \t]{2,} {fprintf(yyout, "\t");} 
[ \s]{2,} {fprintf(yyout, "\t");} 
.       { fprintf(yyout, "%s", yytext); } 
%% 


int main()
{
	yyin = fopen("no_comm.go","r");
	yyout = fopen("var_input.go","w");
	yylex();
	fclose(yyin);
	fclose(yyout);
	return 0;	
	
}
