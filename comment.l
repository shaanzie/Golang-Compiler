%{
	#include<iostream>
	#include<fstream>
	using namespace std;
	int single = 0;
	int multi = 0;
%}

%%
\t(\/[\/].)*\n  {++single;}
\t"/*"([^+]|\*+[^*/])*\*+"/"\n {++multi;}
%%

int main()
{
	
	yyin = fopen("sample.txt","r");
	yylex();
	cout<<"no. of single line comments = "<< single<<endl;
	cout<<"no of multi line comment = "<<multi<<endl;
	return 0;	
	
}
