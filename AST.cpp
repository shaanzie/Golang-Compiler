#include<bits/stdc++.h>

using namespace std;

typedef struct TreeNode {
    string data;
    struct TreeNode* left;
    struct TreeNode* right;
    struct TreeNode* middle;
} TreeNode;

TreeNode* init() {
    TreeNode* head = (TreeNode*)malloc(sizeof(TreeNode));
    head->left = NULL;
    head->right = NULL;
    head->middle = NULL;
}



int main()
{
    ifstream ip;
    ip.open("parsed_input.go", ios::in);

    TreeNode* head = init();

    string text;
    vector<string> keywords = {"for", "if"};
    while(getline(ip, text))
    {
        for(auto i : text)
        {
            
        }
    }

}