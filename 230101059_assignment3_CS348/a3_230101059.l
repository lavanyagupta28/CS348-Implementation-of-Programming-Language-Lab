%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line_no = 1;
FILE *tok_fp;
FILE *sym_fp;

#define MAX_SYMBOLS 1000
#define MAX_LEN 100

char symbol_table[MAX_SYMBOLS][MAX_LEN];
int symbol_count = 0;

int lookup_symbol(char *s) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbol_table[i], s) == 0)
            return i;
    }
    return -1;
}

void insert_symbol(char *s) {
    if (lookup_symbol(s) == -1) {
        strcpy(symbol_table[symbol_count], s);
        symbol_count++;
    }
}

void write_symbol_table() {
    fprintf(sym_fp, "Index\tIdentifier\n");
    for (int i = 0; i < symbol_count; i++) {
        fprintf(sym_fp, "%d\t%s\n", i + 1, symbol_table[i]);
    }
}
%}

%x COMMENT

LETTER      [a-zA-Z_]
DIGIT       [0-9]
NZDIGIT     [1-9]
ID          {LETTER}({LETTER}|{DIGIT})*
INTCONST    0|{NZDIGIT}{DIGIT}*
FLOATCONST  ({DIGIT}+\.{DIGIT}*)|({DIGIT}*\.{DIGIT}+)
ESC         \\\'|\\\"|\\\?|\\\\|\\a|\\b|\\f|\\n|\\r|\\t|\\v
CHARCONST   \'([^\\\'\n]|{ESC})\'
STRINGLIT   \"([^\\\"\n]|{ESC})*\"
WS          [ \t\r]+

%%

\n                      { line_no++; }
{WS}                    { }

"/*"                    { BEGIN(COMMENT); }
<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { line_no++; }
<COMMENT>.              { }
<COMMENT><<EOF>>        {
                            fprintf(tok_fp, "Line %d: Lexical Error: Unterminated block comment\n", line_no);
                            yyterminate();
                        }

"//".*                  { }

"break"                 { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"case"                  { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"char"                  { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"continue"              { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"default"               { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"do"                    { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"double"                { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"else"                  { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"float"                 { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"for"                   { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"if"                    { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"int"                   { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"long"                  { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"return"                { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"short"                 { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"signed"                { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"static"                { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"unsigned"              { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"void"                  { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"while"                 { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }
"_Bool"                 { fprintf(tok_fp, "Line %d: <KEYWORD, %s>\n", line_no, yytext); }

{DIGIT}+\.{DIGIT}*\.({DIGIT}|\.)*  {
                            fprintf(tok_fp, "Line %d: Lexical Error: Malformed float constant '%s'\n", line_no, yytext);
                        }

{FLOATCONST}            { fprintf(tok_fp, "Line %d: <FLOAT_CONSTANT, %s>\n", line_no, yytext); }

0{DIGIT}+               {
                            fprintf(tok_fp, "Line %d: Lexical Error: Invalid integer constant (leading zeros) '%s'\n", line_no, yytext);
                        }

{INTCONST}              { fprintf(tok_fp, "Line %d: <INTEGER_CONSTANT, %s>\n", line_no, yytext); }

{CHARCONST}             { fprintf(tok_fp, "Line %d: <CHAR_CONSTANT, %s>\n", line_no, yytext); }

\'([^\\\'\n]|{ESC})\n   {
                            fprintf(tok_fp, "Line %d: Lexical Error: Unterminated character constant\n", line_no);
                            line_no++;
                        }

\'([^\\\'\n]|{ESC})     {
                            fprintf(tok_fp, "Line %d: Lexical Error: Unterminated character constant\n", line_no);
                        }

\'\'                    {
                            fprintf(tok_fp, "Line %d: Lexical Error: Empty character constant\n", line_no);
                        }

{STRINGLIT}             { fprintf(tok_fp, "Line %d: <STRING_LITERAL, %s>\n", line_no, yytext); }

\"([^\\\"\n]|{ESC})*\n  {
                            fprintf(tok_fp, "Line %d: Lexical Error: Unterminated string literal (newline)\n", line_no);
                            line_no++;
                        }

\"([^\\\"\n]|{ESC})*    {
                            fprintf(tok_fp, "Line %d: Lexical Error: Unterminated string literal (EOF)\n", line_no);
                        }

{DIGIT}+{LETTER}({LETTER}|{DIGIT})* {
                            fprintf(tok_fp, "Line %d: Lexical Error: Invalid token (identifier cannot start with digit) '%s'\n", line_no, yytext);
                        }

{ID}                    {
                            fprintf(tok_fp, "Line %d: <IDENTIFIER, %s>\n", line_no, yytext);
                            insert_symbol(yytext);
                        }

"..."                   { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"<<="                   { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
">>="                   { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"->"                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"++"                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"--"                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"<<"                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
">>"                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"<="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
">="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"=="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"!="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"&&"                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"||"                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"*="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"/="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"%="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"+="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"-="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"&="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"^="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"|="                    { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"["                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"]"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"("                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
")"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"{"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"}"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"."                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"&"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"*"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"+"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"-"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"~"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"!"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"/"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"%"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"<"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
">"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"^"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"|"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"?"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
":"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
";"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"="                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
","                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }
"#"                     { fprintf(tok_fp, "Line %d: <PUNCTUATOR, %s>\n", line_no, yytext); }

.                       {
                            fprintf(tok_fp, "Line %d: Lexical Error: Unknown character '%s'\n", line_no, yytext);
                        }

%%

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <inputfile>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        fprintf(stderr, "Error: Cannot open input file '%s'\n", argv[1]);
        return 1;
    }

    tok_fp = fopen("a3_230101059_token.txt", "w");
    sym_fp = fopen("a3_230101059_st.txt", "w");

    if (!tok_fp || !sym_fp) {
        fprintf(stderr, "Error: Cannot open output files\n");
        return 1;
    }

    yylex();

    write_symbol_table();

    fclose(yyin);
    fclose(tok_fp);
    fclose(sym_fp);

    printf("Tokenization complete.\n");
    printf("  Tokens  -> a3_230101059_token.txt\n");
    printf("  Symbols -> a3_230101059_st.txt\n");

    return 0;
}

int yywrap() {
    return 1;
}
