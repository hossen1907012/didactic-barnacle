%{
    #include <bits/stdc++.h>
    using namespace std;

    unordered_map<string, int> variable_map;
    int token_count = 0;
    int line_count = 0;

    vector<string> tokens = {
        "print", "if", "number", "string", "while"
    };

    vector<string> file_contents;
%}

LETTER [A-Za-z]
DIGIT [0-9]
ARTH_OPS [+|-|*|/]
REL_OPS "=="|">="|"<="|"<"|"<"|">"|"!="

var_name_pattern {LETTER}({LETTER}|{DIGIT})*
text_pattern ["\""]({LETTER}|{DIGIT}|[ ])*["\""]
number_pattern {DIGIT}*(["."]{DIGIT}*)?
literals {text_pattern}|{number_pattern}|[ ]*

str_var_pattern string[ ]*{var_name_pattern}([ ]*["="][ ]*["\""]({LETTER}|{DIGIT})*["\""])?[";"]
num_var_pattern number[ ]*{var_name_pattern}([ ]*["="][ ]*{DIGIT}*(["."]{DIGIT}*)?)?[";"]
arth_expr ({literals}|{var_name_pattern})+[ ]*{ARTH_OPS}[ ]*({literals}|{var_name_pattern})+
rel_expr ({literals}|{arth_expr}|{var_name_pattern})+[ ]*{REL_OPS}[ ]*({literals}|{arth_expr}|{var_name_pattern})+
print_pattern print[\(]({literals}|{arth_expr})[\)][";"]
STATEMENT {str_var_pattern}|{num_var_pattern}|{arth_expr}|{rel_expr}|{print_pattern}

if_block if[ ]*[\(][ ]*{rel_expr}[ ]*[\)][ ]*["{"]{STATEMENT}*["}"]
else_block else[ ]*(["{"]{STATEMENT}["}"])?{if_block}?
CONDITION {if_block}([ ]*{else_block})*

while_loop while[ ]*[\(][ ]*{rel_expr}[ ]*[\)][ ]*["{"]{STATEMENT}*["}"]

%%
{CONDITION}|{STATEMENT}|{while_loop} {
    file_contents.push_back(yytext);
    
}
%%


int yywrap()
{
    return 1;
}
int main()
{ 
    yyin = fopen("playground.zm", "r");
    yylex();

    cout << "Number of lines: " << file_contents.size() << endl;

    exit(0);
}