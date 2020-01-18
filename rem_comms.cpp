#include<bits/stdc++.h>

using namespace std;

string comment_parser(string s)
{
    string out;
    for(int i = 0; i < s.length(); i++)
    {
        if(s[i] == '/')
        {
            if(s[i+1] == '/')
            {
                while(s[i] != '\n')
                    i++;
                continue;
            }
            else if(s[i+1] == '*')
            {
                i+=2;
                while(s[i] != '*' && s[i+1] != '/')
                {
                    i++;
                }
                i+=2;
                continue;
            }
            else
            {
                exit(0);
            }
        }
        else
            out += s[i];
    }
    return out;
}

int main()
{
    string text;
    string inp_text;
    ifstream ip;
    ofstream op;
    ip.open("input.go", ios::in); 
    
    if(!ip)
    {   
        cout<<"File not opened"; 
        exit(0);
    }
    string out;
    while(getline(ip, text))
    {
        op.open("no_comment.go", ios::out | ios::app);
        op<<comment_parser(text);
        op<<'\n';
        op.close();
    }
    ip.close();
    return 0;
}