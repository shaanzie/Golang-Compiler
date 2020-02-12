%% 
[ \t]{2,} {fprintf(yyout, "\t");} 
[ \s]{2,} {fprintf(yyout, "\t");} 
.       { fprintf(yyout, "%s", yytext); } 
%% 


int main()
{
	yyin = fopen("no_comm.txt","r");
	yyout = fopen("no_ws.txt","w");
	yylex();
	return 0;	
	
}
