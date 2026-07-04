%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h" /* Crucial: includes token definitions from Bison */

int line_no = 1;

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
{WS}                    { /* Ignore whitespace */ }

"/*"                    { BEGIN(COMMENT); }
<COMMENT>"*/"           { BEGIN(INITIAL); }
<COMMENT>\n             { line_no++; }
<COMMENT>.              { }
<COMMENT><<EOF>>        { 
                            printf("Line %d: Lexical Error: Unterminated comment\n", line_no); 
                            return 0; 
                        }

"//".* { /* Ignore single line comments */ }

"break"                 { return BREAK; }
"default"               { return DEFAULT; }
"return"                { return RETURN; }
"void"                  { return VOID; }
"case"                  { return CASE; }
"float"                 { return FLOAT; }
"short"                 { return SHORT; }
"double"                { return DOUBLE; }
"char"                  { return CHAR; }
"for"                   { return FOR; }
"signed"                { return SIGNED; }
"while"                 { return WHILE; }
"else"                  { return ELSE; }
"unsigned"              { return UNSIGNED; }
"long"                  { return LONG; }
"_Bool"                 { return BOOL; }
"continue"              { return CONTINUE; }
"if"                    { return IF; }
"static"                { return STATIC; }
"do"                    { return DO; }
"int"                   { return INT; }
"..."                   { return ELLIPSIS; }

{FLOATCONST}            { return CONSTANT; }

({DIGIT}*\.{DIGIT}*\.{DIGIT}*[0-9.]*) {
    printf("Line %d: Lexical Error: Malformed float constant '%s'\n", line_no, yytext);
}

{INTCONST}              { return CONSTANT; }

0{DIGIT}+               {
    printf("Line %d: Lexical Error: Leading zeros not allowed '%s'\n", line_no, yytext);
}

{CHARCONST}             { return CONSTANT; }

\'([^\\\'\n]|{ESC})     { printf("Line %d: Lexical Error: Unterminated character constant\n", line_no); }

{STRINGLIT}             { return STRING_LITERAL; }

\"([^\\\"\n]|{ESC})*\n  {
                            printf("Line %d: Lexical Error: Unterminated string literal\n", line_no);
                            line_no++;
                        }

\"([^\\\"\n]|{ESC})* { printf("Line %d: Lexical Error: String literal reaches EOF\n", line_no); }

{ID}                    {
                            insert_symbol(yytext);
                            return IDENTIFIER;
                        }

{DIGIT}+{LETTER}+({LETTER}|{DIGIT})* {
    printf("Line %d: Lexical Error: Identifier cannot start with a digit '%s'\n", line_no, yytext);
}

"++"                    { return INC_OP; }
"--"                    { return DEC_OP; }
"<<="                   { return LEFT_ASSIGN; }
">>="                   { return RIGHT_ASSIGN; }
"<<"                    { return LEFT_OP; }
">>"                    { return RIGHT_OP; }
"<="                    { return LE_OP; }
">="                    { return GE_OP; }
"=="                    { return EQ_OP; }
"!="                    { return NE_OP; }
"&&"                    { return AND_OP; }
"||"                    { return OR_OP; }
"*="                    { return MUL_ASSIGN; }
"/="                    { return DIV_ASSIGN; }
"%="                    { return MOD_ASSIGN; }
"+="                    { return ADD_ASSIGN; }
"-="                    { return SUB_ASSIGN; }
"&="                    { return AND_ASSIGN; }
"^="                    { return XOR_ASSIGN; }
"|="                    { return OR_ASSIGN; }

"["                     { return yytext[0]; }
"]"                     { return yytext[0]; }
"("                     { return yytext[0]; }
")"                     { return yytext[0]; }
"{"                     { return yytext[0]; }
"}"                     { return yytext[0]; }
"."                     { return yytext[0]; }
"&"                     { return yytext[0]; }
"*"                     { return yytext[0]; }
"+"                     { return yytext[0]; }
"-"                     { return yytext[0]; }
"~"                     { return yytext[0]; }
"!"                     { return yytext[0]; }
"/"                     { return yytext[0]; }
"%"                     { return yytext[0]; }
"<"                     { return yytext[0]; }
">"                     { return yytext[0]; }
"^"                     { return yytext[0]; }
"|"                     { return yytext[0]; }
"?"                     { return yytext[0]; }
":"                     { return yytext[0]; }
";"                     { return yytext[0]; }
"="                     { return yytext[0]; }
","                     { return yytext[0]; }
"#"                     { return yytext[0]; }

.                       {
                            printf("Line %d: Lexical Error: Unknown character %s\n", line_no, yytext);
                        }

%%

int yywrap() {
    return 1;
}