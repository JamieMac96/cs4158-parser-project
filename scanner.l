
%{
#include "tokens.h"
#include <string.h>
}%

%%

[\t ]+ /*Ignore whitespace*/

//the regex ?i: is for case insensitivity

(?i:BEGINNING)          { return BEGINNING; }
(?i:BODY)               { return BODY; }
(?i:END)                { return END; }
(?i:MOVE)               { return MOVE; }
(?i:ADD)                { return ADD; }
(?i:INPUT)              { return INPUT; }
(?i:PRINT)              { return PRINT; }
(?i:TO)                 { return TO; }
[Xx+]                   { yylval.size = strlen(yytext); return INTEGER_SIZE; }
;                       { return SEMI_COLON; }
\.                      { return TERMINATOR; }
[A-Za-z][A-Za-z0-9\-]*  { yyval.name = yytext; return IDENTIFIER;}
\"(\\.|[^"\\])*\"       { return STRING_LITERAL; }
[0-9]+                  { yylval.num = atoi(yytext); return INTEGER; }
.                       { printf("Invalid Syntax \n"); return 0;}

%%

int yywrap(void){
    return 1;
}


