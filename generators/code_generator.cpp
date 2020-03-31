#include<bits/stdc++.h>

using namespace std;


typedef struct Triples {

    string op;
    string arg1;
    string arg2;
    string res;
    struct Triples* next;

}Triples;

void print3AC(Triples* head);

Triples* assignment(string assign)
{
    Triples* send = (Triples*)malloc(sizeof(Triples));
    send->op = ":=";
    int flag = 0;
    for(int i = 0; i<assign.length(); i++)
    {
        if(assign[i] == ':' || assign[i] == '=')
        {    
            flag = 1;
            continue;
        }
        else if(flag == 0)
            send->arg1 += assign[i];
        
        else
            send->arg2 += assign[i];
    }
    send->res = "assignment";
    return send;
}

Triples* compare(string assign)
{
    Triples* send = (Triples*)malloc(sizeof(Triples));
    int flag = 0;
    for(int i = 0; i<assign.length(); i++)
    {
        if(!isdigit(assign[i]) && !isalpha(assign[i]))
        {    
            send->op += assign[i];
            flag = 1;
        }
        else if(flag == 0)
            send->arg1 += assign[i];
        
        else
            send->arg2 += assign[i];
    }
    send->res = "branch";
    return send;
}

Triples* sequence(string assign)
{
    Triples* send = (Triples*)malloc(sizeof(Triples));
    int flag = 0;
    for(int i = 0; i<assign.length(); i++)
    {
        if(!isdigit(assign[i]) && !isalpha(assign[i]))
        {   
            if(flag == 1) 
                send->op += assign[i];
            flag++;
        }
        else if(flag == 0)
            send->res += assign[i];
        else if(flag == 1)
            send->arg1 += assign[i];
        else
            send->arg2 += assign[i];
    }
    return send;
}

Triples* increment(string command)
{

    Triples* send = (Triples*)malloc(sizeof(Triples));
    int flag = 0;
    for(int i = 0; i<command.length(); i++)
    {
        if(!isdigit(command[i]) && !isalpha(command[i]) || flag == 1)
        {
            flag = 1;
            send->op += command[i];
        }
        else
        {
            send->arg1 += command[i];
        }
    }
    send->arg2 = "1";
    send->res = send->arg1;
    return send;
}

Triples* assign_for(vector<string>& text)
{
    string assign;
    string relop;
    string inc;
    int j = 0;

    for(j = 0; text[0][j] != '('; j++) ;
    j++;

    string res;
    for(int k = j; text[0][k] !=  ':'; k++)
    {
        res += text[0][k];
    }
    
    for(; text[0][j] != ';'; j++) assign += text[0][j];
    j++;
    
    for(; text[0][j] != ';'; j++) relop += text[0][j];
    j++;
    
    for(; text[0][j] != ')'; j++) inc += text[0][j];

    Triples* head = assignment(assign);
    Triples* headcopy = head;
    
    Triples* second = compare(relop);
    head->next = second;
    head = head->next;

    text.erase(text.begin());
    text.erase(text.begin());
    text.erase(text.end());

    for(auto command : text)
    {
        Triples* add = sequence(command);
        head->next = add;
        head = head->next;
    }

    Triples* third = increment(inc);
    head->next = third;
    head = head->next;
    // print3AC(headcopy);
    return headcopy;
}

Triples* assign_if(vector<string>& text)
{
    string relop;
    
    int j;
    for(j = 0; text[0][j] != '('; j++) ;
    j++;
    for(; text[0][j] != ')'; j++) relop += text[0][j];
    
    
    Triples* head = compare(relop);
    Triples* headcopy = head;

    text.erase(text.begin());
    text.erase(text.begin());
    text.erase(text.end());

    for(auto command : text)
    {
        Triples* add = sequence(command);
        head->next = add;
        head = head->next;
    }
    return headcopy;
}


void print3AC(Triples* head)
{
    // head = head->next;
    while(head != NULL)
    {
        cout<<head->op<<" | "<<head->arg1<<" | "<<head->arg2<<" | "<<head->res<<endl;
        head = head->next;
    }
}


int main()
{
    ifstream ip;
    ip.open("code.go", ios::in);
    string text;
    int flag = 0;
    vector<string> body;
    ofstream op;
    op.open("gen_code.txt", ios::out);
    
    Triples* head = (Triples*)malloc(sizeof(Triples));
    head->next = NULL;
    Triples* headcopy = head;

    head->res = "Result";
    head->arg1 = "Arg1";
    head->arg2 = "Arg2";
    head->op = "Op";
    head->next = NULL;

    while(getline(ip, text))
    {   
        if(flag != 0 && text.find("}") == string::npos)
        {
            body.push_back(text);
        }
        else if(text.find("for") != string::npos)
        {   
            body.push_back(text); 
            flag = 1;
        }
        else if(text.find("if") != string::npos)
        {   
            body.push_back(text); 
            flag = 2;
        }
        else if(text.find("}") != string::npos)
        {    
            body.push_back(text);
            if(flag == 1)
            {    
                Triples* add = assign_for(body);
                head->next = add;
                while(head->next != NULL)
                    head = head->next;
                body.clear();
                flag = 0;
            }
            else if(flag == 2)
            {
                Triples* add = assign_if(body);
                body.clear();
                flag = 0;
                head->next = add;
                while(head->next != NULL)
                    head = head->next;
            }
        }
        else if(text.find(":=") != string::npos)
        {
            
            Triples* add = assignment(text);
            head->next = add;
            head = head->next;   
        }
        else
        {
            Triples* add = sequence(text);
            head->next = add;
            head = head->next;
        }
        
    }
    print3AC(headcopy);
    return 0;
}