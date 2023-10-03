#ifndef LANGUAGE_H
#define LANGUAGE_H

#include <vector>
#include <unordered_map>
#include <variant>
#include <string>
using namespace std;

class Language {
public:
    unordered_map<string, string> token_recognizer_map;
    unordered_map<string, string> string_variable_map;
    unordered_map<string, double> number_variable_map; 
    std::vector<std::string> tokens, file_contents;
    int token_count = 0, line_count = 0;

    Language();
    void process_variable_declaration(std::string);
    void view_all_variables();
    int check_variable_exists(string);
    void process_expressions(string line);
    int process_if_statement(string line);
    int process_while_loop(string line);
    int check_token_exists(string token_name);
    void process_print_pattern(string line);

private:
    vector<string> split_string(const string &input);
    int literals_validity_check(string);
    void initialize_token_recognizer();
    void writeTokenInfo(vector<string>);
};

#endif
