%{
    #include <bits/stdc++.h>
    using namespace std;

    unordered_map<string, int> variable_map;
    int token_count;
    int line_count;
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
arth_expr {literals}+[ ]*{ARTH_OPS}[ ]*{literals}+
rel_expr ({literals}|{arth_expr})+[ ]*{REL_OPS}[ ]*({literals}|{arth_expr})+
print_pattern print[\(]({literals}|{arth_expr})[\)][";"]
STATEMENT {str_var_pattern}|{num_var_pattern}|{arth_expr}|{rel_expr}|{print_pattern}

if_block if[ ]*[\(][ ]*{rel_expr}[ ]*[\)][ ]*["{"]{STATEMENT}*["}"]
else_block else[ ]*(["{"]{STATEMENT}["}"])?{if_block}?
CONDITION {if_block}([ ]*{else_block})*

while_loop while[ ]*[\(][ ]*{rel_expr}[ ]*[\)][ ]*["{"]{STATEMENT}*["}"]

%%
{CONDITION} {cout << "Condition" << endl;}
{STATEMENT} {cout << "Voila" << endl;}
{while_loop} {cout << "While loop correct" << endl;}
%%


int yywrap()
{
    return 1;
}
int main()
{ 
    yyin = fopen("playground.zm", "r");
    yylex();
    exit(0);
}