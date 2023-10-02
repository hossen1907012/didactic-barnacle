%{
    #include <iostream>
    #include "language.h"
    using namespace std;

    Language language = Language();
%}

LETTER [A-Za-z]
DIGIT [0-9]
ARTH_OPS [+|-|*|/]
REL_OPS "=="|">="|"<="|"<"|"<"|">"|"!="

var_name_pattern {LETTER}({LETTER}|{DIGIT})*
text_pattern ["\""]({LETTER}|{DIGIT}|[ ])*["\""]
number_pattern {DIGIT}*(["."]{DIGIT}*)?
literals {text_pattern}|{number_pattern}|[ ]*

str_var_pattern string[ ]+{var_name_pattern}([ ]+["="][ ]+["\""]({LETTER}|{DIGIT})*["\""])?[";"]
num_var_pattern number[ ]+{var_name_pattern}([ ]+["="][ ]+{DIGIT}*(["."]{DIGIT}*)?)?[";"]
arth_expr ({literals}|{var_name_pattern})+[ ]+{ARTH_OPS}[ ]+({literals}|{var_name_pattern})+
rel_expr ({literals}|{arth_expr}|{var_name_pattern})+[ ]+{REL_OPS}[ ]+({literals}|{arth_expr}|{var_name_pattern})+
print_pattern print[\(]({literals}|{arth_expr})[\)][";"]
VARIABLE_DECLARATION {str_var_pattern}|{num_var_pattern}
STATEMENT {str_var_pattern}|{num_var_pattern}|{arth_expr}|{rel_expr}|{print_pattern}

if_block if[ ]+[\(][ ]+{rel_expr}[ ]+[\)][ ]+["{"][ ]+{STATEMENT}*[ ]+["}"]
else_block else[ ]+(["{"][ ]+{STATEMENT}*[ ]+["}"])?{if_block}?
CONDITION {if_block}([ ]+{else_block})*

while_loop while[ ]+[\(][ ]+{rel_expr}[ ]+[\)][ ]+["{"][ ]+{STATEMENT}*[ ]+["}"]

%%
{CONDITION} {
    language.process_if_statement(yytext);
    language.line_count++;
}
{VARIABLE_DECLARATION} {
    language.process_variable_declaration(yytext);
    language.line_count++;
}
{while_loop} {
    language.process_while_loop(yytext);
    language.line_count++;
} 

{arth_expr}|{rel_expr} {
    language.process_expressions(yytext);
    language.line_count++;
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

    //all the variables and values.
    
    cout << "\n\n\nAll the variables: \n";
    language.view_all_variables();
    cout << "\nTotal number of lines: " << language.line_count << endl;
    exit(0);
}