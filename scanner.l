%{
#include "mtokens.h"
#include <string.h>

void printToken(char*, int);
%}

%%

[\t ]+ /*Ignore whitespace*/

(?i:BEGINING)          { printToken("BEGINING", BEGINING); }
(?i:BODY)               { printToken("BODY", BODY); }
(?i:END)                { printToken("END", END); }
(?i:MOVE)               { printToken("MOVE", MOVE); }
(?i:ADD)                { printToken("ADD", ADD); }
(?i:INPUT)              { printToken("INPUT", INPUT); }
(?i:PRINT)              { printToken("PRINT", PRINT); }
(?i:TO)                 { printToken("TO", TO); }
[Xx]+                   { printToken("INTEGER SIZE", INTEGER_SIZE); }
;                       { printToken("SEMICOLON", SEMICOLON); }
\.                      { printToken("TERMINATOR", TERMINATOR); }
[A-Za-z][A-Za-z0-9\-]*  { printToken("IDENTIFIER", IDENTIFIER);}
\"(\\.|[^"\\])*\"       { printToken("STRING LITERAL", STRING_LITERAL); }
[0-9]+                  { printToken("INTEGER", INTEGER); }
.                       { printf("Invalid Syntax \n"); return 0;}

%%

int yywrap(void){
    return 1;
}

int main(){
    yylex();
    return 0;
}

void printToken(char* name, int type){
    printf("%s: %d\n", name, type);
}
