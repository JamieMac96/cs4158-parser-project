%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>


extern int yylex();
extern int yyparse();
void yyerror(const char* s);
extern int yylineno;

typedef struct {
   char* name;
   int size;
} Var;

Var identifiers[256];
int numVars = 0;

void addVariable(int size, char* identifier);
void checkIdentifier(char* identifier);
void moveIntToVar(int val, char* identifier);
void moveVarToVar(char* idOne, char* idTwo);
int variableDefined(char* vName);
void printidentifiers();
%}

%union {int number; int size; char* name;}
%start program
%token <name> IDENTIFIER
%token <size> INT_SIZE
%token <number> INTEGER
%token BEGINING
%token BODY
%token END
%token MOVE
%token TO
%token ADD
%token INPUT
%token PRINT
%token SEMICOLON
%token STRING_LITERAL
%token TERMINATOR


%%
program:            beginning body end {} 
                    ;
beginning:          BEGINING TERMINATOR declarations {}
                    ;
declarations:       declarations declaration
                    | {} 
                    ;
declaration:        INT_SIZE IDENTIFIER TERMINATOR {addVariable($1, $2);}
                    ; 
body:               BODY TERMINATOR operations {}
                    ;
operations:         operations operation {}
                    | {}
                    ;
operation:          move | add | print | input {}
                    ;
move:               MOVE IDENTIFIER TO IDENTIFIER TERMINATOR {moveVarToVar($2, $4);} 
                    | MOVE INTEGER TO IDENTIFIER TERMINATOR {moveIntToVar($2, $4);}
                    ;
add:                ADD IDENTIFIER TO IDENTIFIER TERMINATOR {checkIdentifier($2); checkIdentifier($4);}
                    | ADD INTEGER TO IDENTIFIER TERMINATOR {checkIdentifier($4);}
                    ;
print:              PRINT print_arg {}
                    ;
print_arg:          STRING_LITERAL SEMICOLON print_arg {}
                    | IDENTIFIER SEMICOLON print_arg {checkIdentifier($1);}
                    | STRING_LITERAL TERMINATOR {}
                    | IDENTIFIER TERMINATOR {checkIdentifier($1);}
                    ;
input:              INPUT input_arg {}
                    ;
input_arg:          IDENTIFIER SEMICOLON input_arg {}
                    | IDENTIFIER TERMINATOR {checkIdentifier($1);}
                    ;
end:                END TERMINATOR {} 
                    ;

%%

int main(){
    return yyparse();
}

void addVariable(int size, char*  identifier){

    if(variableDefined(identifier) != -1){
        fprintf(stderr, "Error on line %d: Variable %s already exists\n", yylineno, identifier);
        return;
    }

    numVars++;

    Var var;
    char* temp = (char *) calloc(strlen(identifier)+1, sizeof(char));
    strcpy(temp, identifier);
    var.name = temp;
    var.size = size;
    identifiers[numVars - 1] = var; 
}

void checkIdentifier(char* identifier){

    if(variableDefined(identifier) == -1){
        fprintf(stderr, "Error on line %d: Variable %s  does not exist\n", yylineno, identifier);
    } 
}

void moveIntToVar(int val, char* identifier){
    int varIndex = variableDefined(identifier);
    if(varIndex == -1){
        fprintf(stderr, "Error on line %d:  variable %s does not exist\n", yylineno, identifier);
    }
    else{
        int maxSize = identifiers[varIndex].size;
        int nDigits = floor(log10(abs(val))) + 1;
        if(nDigits > maxSize){
            fprintf(stderr, "Warning on line %d: value %d was too large for variable %s of size %d\n", yylineno, val, identifier, maxSize);
        }
    }
}
void moveVarToVar(char* idOne, char* idTwo){
    int varOneIndex = variableDefined(idOne);
    int varTwoIndex = variableDefined(idTwo);
    
    if(varOneIndex == -1){
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, idOne);
        return;
    }
    else if(varTwoIndex == -1){
        fprintf(stderr, "Error on line %d: Variable %s does not exist\n", yylineno, idTwo);
        return;
    }
    else{
        int varOneSize = identifiers[varOneIndex].size;
        int varTwoSize = identifiers[varTwoIndex].size;
        
        if(varOneSize > varTwoSize){
            fprintf(stderr, "Warning on line %d: Cannot assign variable of size %d to variable of size %d\n", yylineno, varOneSize, varTwoSize);
        }
    }
}


void yyerror(const char *s) {
    fprintf(stderr, "Error one line %d: %s\n", yylineno, s);
}

int variableDefined(char * vName){
    
    int i;
    for(i = 0; i < numVars; i++){
        if(identifiers[i].name != NULL){
            if(strcmp(identifiers[i].name, vName) == 0){
                return i;
            }
        }
    }    
    
    return -1;
}

int getVariableSize(char* identifier){
    
}

void printidentifiers(){
    int i;
    
    fprintf(stderr, "printing identifiers:\n");    

    for(i = 0; i < numVars; i++){
        fprintf(stderr, "%d: %s\n", i,  identifiers[i].name);
    }
    fprintf(stderr, "\n\n\n");
}
