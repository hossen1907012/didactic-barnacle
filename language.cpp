#include "language.h"
#include <bits/stdc++.h>
#include <cctype>
using namespace std;

Language::Language() : tokens{"print", "if", "number", "string", "while"}
{
    this->initialize_token_recognizer();
}

/**
 * Variable declaration contains 3 parts.
 *  - datatype
 *  - variable name
 *  - assigned value
 *
 * We have only 2 datatype: string, number. Both of them is of 6 character. So, it is a simple operation.
 */
void Language::process_variable_declaration(string line)
{
    line = line.substr(0, (line.length() - 1));                // eliminate `;` at the end.
    std::vector<std::string> words = this->split_string(line); // words[0] => datatype, words[1] => var_name, words[3] => value.
    this->token_count = words.size() + 1;                      // extra 1 for ;

    if (words.size() > 2)
    {
        if (words[0] == "number")
        {
            double data = stod(words[3]);
            string var_name = words[1];
            this->number_variable_map[var_name] = data;
        }
        else
        {
            string data = words[3];
            string var_name = words[1];
            this->string_variable_map[var_name] = data;
        }
    }
    else
    {
        if (words[0] == "number")
        {
            double data = 0.0;
            string var_name = words[1];
            this->number_variable_map[var_name] = data;
        }
        else
        {
            string data = words[3];
            string var_name = words[1];
            this->string_variable_map[var_name] = data;
        }
    }
}

int Language::process_expressions(string line)
{
    std::vector<std::string> tkns = this->split_string(line);
    this->token_count = tkns.size() + 1;

    for (int i = 0; i < tkns.size(); i++)
    {
        if (this->check_token_exists(tkns[i]))
        {
            cout << "token: " << tkns[i] << " :\t" << this->token_recognizer_map[tkns[i]] << endl;
        }
        else
        {
            cout << "token: " << tkns[i] << endl;
        }
    }
    return 1;
}

int Language::process_if_statement(string line)
{
    std::vector<std::string> tkns = this->split_string(line);
    this->token_count = tkns.size() + 1;

    string literal_1 = tkns[2];
    string literal_2 = tkns[4];
    string _oprtr = tkns[3];

    int ltr1_valid = this->variable_validity_check(literal_1);
    int ltr2_valid = this->variable_validity_check(literal_2);

    if (!ltr1_valid || !ltr2_valid)
    {
        return 0;
    }

    for (int i = 0; i < tkns.size(); i++)
    {
        if (this->check_token_exists(tkns[i]))
        {
            cout << "token: " << tkns[i] << " :\t" << this->token_recognizer_map[tkns[i]] << endl;
        }
        else
        {
            cout << "token: " << tkns[i] << endl;
        }
    }

    return ltr1_valid && ltr2_valid;
}

int Language::process_while_loop(string line)
{
    std::vector<std::string> tkns = this->split_string(line);
    this->token_count = tkns.size() + 1;

    string literal_1 = tkns[2];
    string literal_2 = tkns[4];
    string _oprtr = tkns[3];

    int ltr1_valid = this->variable_validity_check(literal_1);
    int ltr2_valid = this->variable_validity_check(literal_2);

    if (!ltr1_valid || !ltr2_valid)
    {
        return 0;
    }

    for (int i = 0; i < tkns.size(); i++)
    {
        if (this->check_token_exists(tkns[i]))
        {
            cout << "token: " << tkns[i] << " :\t" << this->token_recognizer_map[tkns[i]] << endl;
        }
        else
        {
            cout << "token: " << tkns[i] << endl;
        }
    }

    return ltr1_valid && ltr2_valid;
}

/**
 *  Utility functions.
 *
 *
 */

int Language::check_variable_exists(string var_name)
{ // return 1 if variable found and 0 if variable not found.
    auto it = this->number_variable_map.find(var_name);
    return it != this->number_variable_map.end() ? 1 : 0;
}

int Language::check_token_exists(string token_name)
{ // return 1 if token found and 0 if token not found.
    auto it = this->token_recognizer_map.find(token_name);
    return it != this->token_recognizer_map.end() ? 1 : 0;
}

void Language::view_all_variables()
{
    for (const auto &pair : this->number_variable_map)
    {
        cout << pair.first << " = " << pair.second << endl;
    }

    for (const auto &pair : this->string_variable_map)
    {
        cout << pair.first << " = " << pair.second << endl;
    }
}

vector<string> Language::split_string(const string &input)
{
    vector<string> words;
    istringstream iss(input);
    string word;

    while (iss >> word)
    {
        words.push_back(word);
    }

    return words;
}

int Language::variable_validity_check(string variable_name)
{
    if (variable_name[0] != '\"' || variable_name[variable_name.length() - 1] != '\"')
    {
        if (!isdigit(variable_name[0]))
        {
            if (!this->check_variable_exists(variable_name))
            {
                cout << "Invalid operation. " << variable_name << " doesn't exist" << endl;
                return 0;
            }
        }
    }
    return 1;
}

void Language::initialize_token_recognizer()
{
    this->token_recognizer_map["while"] = "While loop";
    this->token_recognizer_map["("] = "Left parenthesis";
    this->token_recognizer_map[")"] = "Right parenthesis";
    this->token_recognizer_map["{"] = "Left Curly braces. Starting a block";
    this->token_recognizer_map["}"] = "Right Curly braces. Ending a block.";
    this->token_recognizer_map["if"] = "if block";
    this->token_recognizer_map["else"] = "else ";
    this->token_recognizer_map["string"] = "string type variable declaration.";
    this->token_recognizer_map["number"] = "number type variable declaration";
    this->token_recognizer_map["="] = "Assigning to variable.";
    this->token_recognizer_map["+"] = "Addition";
    this->token_recognizer_map["-"] = "Subtraction";
    this->token_recognizer_map["*"] = "Multiplication";
    this->token_recognizer_map["/"] = "Division";
    this->token_recognizer_map["=="] = "is equal";
    this->token_recognizer_map["!="] = "is not equal";
    this->token_recognizer_map[">"] = "less than";
    this->token_recognizer_map["<"] = "greater than";
    this->token_recognizer_map[">="] = "less than or equal";
    this->token_recognizer_map["<="] = "greater than or equal";
    this->token_recognizer_map[";"] = "Semicolon. Closing an statement.";
    this->token_recognizer_map[""] = "Null string";
}