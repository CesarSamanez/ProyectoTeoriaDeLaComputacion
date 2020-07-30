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
%token EOL SQRT MOD
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

exp:    NUM                 { $$ = $1; }                /* Detecta un numero */
        |'-' NUM            { $$ = -1 * $2; }           /* Numero negativo */
        |exp '+' exp        { $$ = $1 + $3; }           /* Suma */
        |exp '-' exp        { $$ = $1 - $3; }           /* Resta */
        |exp '*' exp        { $$ = $1 * $3; }           /* Division */
        |exp '/' exp        {
                                if($3 != 0){            /* Verificacion errores division por 0 */
                                    $$ = $1 / $3;
                                }else{
                                    $$ = -1;
                                    yyerror("No existe division entre cero\n");
                                }
                            }
        |exp MOD exp        { $$ = fmod($1, $3); }      /* Modulo de un numero */
        |exp '^' exp        { $$ = pow($1, $3); }       /* Potencia */
        |SQRT exp           { $$ = sqrt($2); }          /* Raiz cuadrada */
        |SEN exp            { $$ = sin($2); }           /* Funcion seno */
        |COS exp            { $$ = cos($2); }           /* Funcion coseno */
        |TAN exp            { $$ = tan($2); }           /* Funcion tangente */
        |ASEN exp           { $$ = asin($2); }          /* Funcion arco_seno */
        |ACOS exp           { $$ = acos($2); }          /* Funcion arco_coseno */
        |ATAN exp           { $$ = atan($2); }          /* Funcion arco_tangente */
        |LOG10 exp          { $$ = log10($2); }         /* Logaritmo base 10 */
        |LOG exp            { $$ = log($2); }           /* Logaritmo */
        |'|' exp '|'        { $$ = abs($2); }           /* Valor absoluto */
        |'(' exp ')'        { $$ = $2; }                /* Reconocimiento agrupaciones por '()' */
;

%%

void yyerror(char *s){
    printf("ERROR: %s \n", s);
}

int main(int args, char **argv){
    yyparse();
    return 0;
}

