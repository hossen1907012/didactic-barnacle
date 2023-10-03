%{
    //definition
    #include <bits/stdc++.h>
    using namespace std;

    vector<string> variables;
    int token_counter = 0;
    int line_counter = 0;

    std::unordered_map<std::string, std::string> token_informations = {
        {"while", "While loop"},
        {"(", "Left parenthesis"},
        {")", "Right parenthesis"},
        {"{", "Left Curly"},
        {"}", "Right Curly"},
        {"if", "if block"},
        {"else", "else block"},
        {"string", "string variable"},
        {"int", "int variable"},
        {"float", "float variable"},
        {"char", "char variable"},
        {"=", "Assigning to variable."},
        {"+", "Addition"},
        {"-", "Subtraction"},
        {"*", "Multiplication"},
        {"/", "Division"},
        {"==", "Equality comparison"},
        {"!=", "Inequality comparison"},
        {">", "Greater than"},
        {"<", "Less than"},
        {">=", "Greater than or equal"},
        {"<=", "Less than or equal"},
        {";", "Semicolon. Closing a statement."},
        {"", "Null string"},
        {"print", "Printing something"}
    };

    void printToken(vector<string> ltkns){
        for(int i=0; i< ltkns.size(); i++){
            string key = ltkns[i];
            cout << "found " << key << " = " << token_informations[key] << endl;
        }
    }



    vector<string> split_string(const string &input) {
        vector<string> words;
        istringstream iss(input);
        string word;

        while (iss >> word) {
            words.push_back(word);
        }

        return words;
    }

    int check_variable_exists(string vname){
        for(int i=0; i<variables.size(); i++){
            if(variables[i] == vname) return 1;
        }
        return 0;
    }

    int isValidLT(string lt)
    {
        if (lt[0] != '\"' || lt[lt.length() - 1] != '\"')
        {
            if (!isdigit(lt[0]))
            {
                if (check_variable_exists(lt))
                {
                    return 0;
                }
            }
        }
        return 1;
    }
%}

letter [A-Za-z]
digit [0-9]


int int[ ]*{letter}+([ ]*["="][ ]*{digit}*)?[";"]
float int[ ]*{letter}+([ ]*["="][ ]*{digit}*["."]{digit}*)?[";"]
char char[ ]*{letter}+["="][ ]*["\'"]{letter}*["\'"][";"]
variable_string string[ ]*{letter}({letter}|{digit})*([ ]*["="][ ]*["\""]({letter}({letter}|{digit})*)*["\""])?[";"]
variable_array array[ ]*{letter}+["="][ ]*["{"]({int}|{float}[","]({int}|{float}[","])*["}"][";"]
variable {letter}({letter}|{digit})*
text {letter}|{digit}
Arithmetic [+|-|*|/]
Relational "=="|">="|"<="|"<"|">"|"!="
expression {digit}{Arithmetic}{digit}
variable_declare {int}|{float}|{char}|{variable_string}
relational_expression ({text}|{digit}*(["."]{digit}*)?)+[ ]+{Relational}[ ]+({text}|{digit}*(["."]{digit}*)?)+
Print print[ ]+[\(][ ]+["\""]{text}*["\""][ ]+[\)]
others {variable_string}|({letter}["="]{digit})|{relational_expression}|print[\(][ ]+["\""]{text}*["\""][ ]+[\)]

conditional if[ ]+[\(][ ]+{relational_expression}[ ]+[\)][ ]+["{"][ ]+{others}*[ ]+["}"][ ]+(else[ ]+["{"][ ]+{others}[ ]+["}"])*
WhileLoop while[ ]+[\(][ ]+{relational_expression}[ ]+[\)][ ]+["{"][ ]+{others}*[ ]+["}"]
%%
{conditional} {
    vector<string> condi_spl_str = split_string(yytext);
    token_counter += condi_spl_str.size();
    line_counter++;
    printToken(condi_spl_str);
}
{WhileLoop} {
    vector<string> while_splitted_string = split_string(yytext);
    token_counter += while_splitted_string.size();
    line_counter++;
    string lt1 = while_splitted_string[2];
    string lt2 = while_splitted_string[4];
    string oprs = while_splitted_string[3];
    
    int isValidlt1 = isValidLT(lt1);
    int isValidlt2 = isValidLT(lt2);
    printToken(while_splitted_string);
}
{variable_declare} {
    vector<string> var_splitted_string = split_string(yytext);
    token_counter += var_splitted_string.size();
    variables.push_back(var_splitted_string[1]);
    line_counter++;
    printToken(var_splitted_string);
}
{expression}|{relational_expression} {
    vector<string> expr_string_splitted = split_string(yytext);
    token_counter += expr_string_splitted.size();
    line_counter++;
    printToken(expr_string_splitted);

    isValidLT(expr_string_splitted[0]);
    isValidLT(expr_string_splitted[2]);
}

{Print} {
    vector<string> expr_string_splitted = split_string(yytext);
    token_counter += expr_string_splitted.size();
    line_counter++;
    printToken(expr_string_splitted);
}
%%




int yywrap()
{
    return 1;
}
int main()
{ 
    yyin = fopen("input.txt", "r");
    yylex();

    cout << "\n\nTotal line count: " << line_counter << endl;
    cout << "\nTotal token count: " << token_counter << endl;

    exit(0);
}