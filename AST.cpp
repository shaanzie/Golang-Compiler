#include<bits/stdc++.h>

using namespace std;

struct condNode;



typedef struct container {
    string text;
    struct condNode* nextassign;
    struct forNode* nextfor;
    struct ifNode* nextif;
    struct container* next;

}container;


typedef struct assignNode {

    string left;
    string right;
    string op;

}assignNode;

typedef struct condNode {

    string left;
    string right;
    string op;

}condNode;

typedef struct forNode {

    string text;
    condNode* condition;
    assignNode* assign;
    condNode* update;
    container* statements;

}forNode;

typedef struct ifNode {
    string text;
    condNode* condition;
    container* statements;

}ifNode;

void assign_for(container* head, vector<string> text);
void assign_if(container* head, vector<string> text);
void assign_text(container* head, string text);

container* init()
{
    container* head = (container*)malloc(sizeof(container));
    head->text = "Start";
    return head;
}


container* parse_container(vector<string> text)
{
    container* head = init();
    container* temp = head;
    int flag = 0;
    vector<string> body;
    for(auto stmt : text)
    {
        if(flag != 0 && stmt.find("}") == string::npos)
        {
            body.push_back(stmt);
        }
        else if(stmt.find("for") != string::npos)
        {   
            body.push_back(stmt); 
            flag = 1;
        }
        else if(stmt.find("if") != string::npos)
        {   
            body.push_back(stmt); 
            flag = 2;
        }
        else if(stmt.find("}") != string::npos)
        {    
            body.push_back(stmt);
            if(flag == 1)
            {    
                assign_for(head, body);
                body.clear();
                flag = 0;
            }
            else
            {
                assign_if(head, body);
                body.clear();
                flag = 0;
            }
        }
        else    
            assign_text(head, stmt);

        head->next = (container*)malloc(sizeof(container));
        head = head->next;
    }

    return temp;
}

int notOp(char op)
{
    if(op == '>' || op == '<' || op == '=')
        return 1;
    return 0;
}

string removews(string text)
{
    string news = "";
    for(auto i : text)
    {
        if(i != ' ')
            news += text[i];
    }
    return news;
}

condNode* cond_parse(string text)
{
    condNode* newnode = (condNode*)malloc(sizeof(condNode));
    int i;
    string left = "", right = "";
    string op = "";
    for(i = 0; isalpha(text[i]); i++) left += text[i];
    for(; !isalnum(text[i]); i++) op += text[i];
    for(; i <text.length(); i++) right += text[i];
    newnode->left = left;
    newnode->right = right;
    newnode->op = op;
    return newnode;
}

assignNode* cond_assign(string text)
{
    assignNode* newnode = (assignNode*)malloc(sizeof(assignNode));
    int i;
    string left, op, right;
    for(i = 0; text[i] != ':'; i++) left += text[i];
    op = ":=";
    i+=2;
    for(; i <text.length(); i++) right += text[i];
    newnode->op = op;
    newnode->left = left;
    newnode->right = right;
    return newnode;
}

condNode* cond_update(string text)
{
    condNode* newnode = (condNode*)malloc(sizeof(condNode));
    int i;
    string left = "", right, op = "";
    for(i = 0; isalpha(text[i]); i++)   left += text[i];
    for(; i<text.length(); i++)    op+=text[i];
    // cout<<left<<" "<<op<<endl;
    newnode->left = left;
    newnode->right = "None";
    newnode->op = op;
    // cout<<newnode->left<<endl;
    return newnode;
}

void assign_for(container* head, vector<string> text)
{
    forNode* newfor = (forNode*)malloc(sizeof(forNode));

    string assign;
    string relop;
    string inc;
    int j;
    for(j = 0; text[0][j] != '('; j++) ;
    j++;
    for(; text[0][j] != ';'; j++) assign += text[0][j];
    j++;
    for(; text[0][j] != ';'; j++) relop += text[0][j];
    j++;
    for(; text[0][j] != ')'; j++) inc += text[0][j];  

    newfor->condition = cond_parse(relop);
    newfor->assign = cond_assign(assign);
    newfor->update = cond_update(inc);

    text.erase(text.begin());
    text.erase(text.begin());
    text.erase(text.end());
    newfor->text ="for";
    newfor->statements = parse_container(text);
    head->nextfor = newfor;   
    // head->text = "for"; 
}

void assign_if(container* head, vector<string> text)
{
    ifNode* newnode = (ifNode*)malloc(sizeof(ifNode));
    // cout<<text[2]<<endl;

    string relop;
    int j;
    for(j = 0; text[0][j] != '('; j++) ;
    j++;
    for(; text[0][j] != ')'; j++) relop += text[0][j];

    // cout<<relop<<endl;
    newnode->condition = cond_parse(relop);
    newnode->text = "if";
    text.erase(text.begin());
    text.erase(text.begin());
    text.erase(text.end());
    // for(auto i : text)
    //     cout<<i<<endl;
    newnode->statements = parse_container(text);
    // cout<<newnode->text<<endl;
    head->nextif = newnode;
}

void assign_text(container* head, string text)
{
    string left, right;
    condNode* newcond = (condNode*)malloc(sizeof(condNode));
    int i;
    for(i = 0; text[i] != ':'; i++)
    {
        left += text[i];
    }
    i+=2;
    for(; i < text.length(); i++)
    {
        right += text[i];
    }
    newcond->left = left;
    newcond->right = right;
    newcond->op = ":=";
    head->nextassign = newcond;
    // head->text = "assign";
}

void printAST(container* temp)
{

    cout<<temp->text<<endl;
    
    while(temp->next != NULL)
    {
        cout<<temp->nextif->condition->left<<endl;
        temp = temp->next;
    }
}

container* temp = init();

int main()
{
    ifstream ip;
    ip.open("new.go", ios::in);
    container* head = temp;
    string text;
    vector<string> body;
    int flag = 0;
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
            // cout<<text<<endl;
            body.push_back(text); 
            flag = 2;
        }
        else if(text.find("}") != string::npos)
        {    
            body.push_back(text);
            if(flag == 1)
            {    
                assign_for(head, body);
                cout<<head->text<<endl;
                body.clear();
                flag = 0;
            }
            else
            {
                assign_if(head, body);
                cout<<head->text;
                body.clear();
                flag = 0;
            }
        }
        else
        {   
            assign_text(head, text);
            cout<<head->text;
        }

        head->next = (container*)malloc(sizeof(container));
        head = head->next;

    }

    printAST(temp);
    return 0;

}