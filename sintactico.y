%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #define YYDEBUG 1
    extern int yylex(void);
    extern char *yytext;
    void yyerror(char*);
%}

%union{
    double valor;
}

%token <valor> NUM
%token EOL SQRT
%token SEN COS TAN ASEN ACOS ATAN LOG10 LOG

%left '-' '+'
%left '*' '/' 
%right '^'

%type <valor> exp

%%

stm_lst: stm EOL
        |stm_lst stm EOL
;

stm: exp {printf("Resultado = %.2f\n", $1);}
;

exp:    NUM                 { $$ = $1; }
        |'-' NUM            { $$ = -1 * $2; } /* Negative */
        |exp '+' exp        { $$ = $1 + $3; }
        |exp '-' exp        { $$ = $1 - $3; }
        |exp '*' exp        { $$ = $1 * $3; }
        |exp '/' exp        {
                                if($3 != 0){
                                    $$ = $1 / $3;
                                }else{
                                    $$ = -1;
                                    yyerror("No existe division entre cero\n");
                                }
                            }
        |exp '^' exp        { $$ = pow($1, $3); }
        |'(' exp ')'        { $$ = $2; }
        |SQRT exp           { $$ = sqrt($2); }
        |SEN exp            { $$ = sin($2); }
        |COS exp            { $$ = cos($2); }
        |TAN exp            { $$ = tan($2); }
        |ASEN exp           { $$ = asin($2); }
        |ACOS exp           { $$ = acos($2); }
        |ATAN exp           { $$ = atan($2); }
        |LOG10 exp          { $$ = log10($2); }
        |LOG exp            { $$ = log($2); }
        |'|' exp '|'        { $$ = abs($2); }

;

%%

void yyerror(char *s){
    printf("ERROR: %s \n", s);
}

int main(int args, char **argv){
    yyparse();
    return 0;
}

