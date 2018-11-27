%{
#include "y.tab.h"
#include <string.h>

char* temp;

%}

%option yylineno

%%

[\t ]+                  {}
(?i:BEGINING)           { return BEGINING; }
(?i:BODY)               { return BODY; }
(?i:END)                { return END; }
(?i:MOVE)               { return MOVE; }
(?i:ADD)                { return ADD; }
(?i:INPUT)              { return INPUT; }
(?i:PRINT)              { return PRINT; }
(?i:TO)                 { return TO; }
;                       { return SEMICOLON; }
\n                      {}
[0-9]+                  { yylval.number=atoi(yytext); return INTEGER; }
[Xx]+                   { yylval.size=strlen(yytext); return INT_SIZE; }
\.                      { return TERMINATOR; }
[A-Za-z][A-Za-z0-9\-]*  { temp = (char*) calloc(strlen(yytext)+1, sizeof(char)); strcpy(temp, yytext); yylval.name = temp; return IDENTIFIER;}
\"(\\.|[^"\\])*\"       { return STRING_LITERAL; }
.                       { return 0;}

%%

int yywrap(void){
    return 1;
}


