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
   | error_syntax
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
                                    yyerrok;
                                    yyerror("No existe division entre cero");
                                }
                            }
        |exp '%' exp        { $$ = fmod($1, $3); }      /* Modulo de un numero */
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

/* Reconocimiento de posibles errores */
error_syntax: '-'               { yyerrok; yyerror("No se reconoció la operación -> '-'"); }
            | '+'               { yyerrok; yyerror("No se reconoció la operación -> '+'"); }
            | '*'               { yyerrok; yyerror("No se reconoció la operación -> '*'"); }
            | '/'               { yyerrok; yyerror("No se reconoció la operación -> '/'"); }
            | exp '-'           { yyerrok; yyerror("Debe ingresar al menos 1 número después de -> '-'"); }  
            | exp '+'           { yyerrok; yyerror("Debe ingresar al menos 1 número después de -> '+'"); }
            | exp '*'           { yyerrok; yyerror("Debe ingresar al menos 1 número después de -> '*'"); }
            | exp '/'           { yyerrok; yyerror("Debe ingresar al menos 1 número después de -> '/'"); }
            | '%' error_sep     { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | SQRT error_sep    { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | SEN error_sep     { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | COS error_sep     { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | TAN error_sep     { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | ASEN error_sep    { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | ACOS error_sep    { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | ATAN error_sep    { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | LOG10 error_sep   { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | LOG error_sep     { yyerrok; yyerror("Separadores '(' y/o ')'"); }
            | '%'               { yyerrok; yyerror("Sintaxis -> 'value' % 'value'"); }
            | SQRT              { yyerrok; yyerror("Sintaxis -> sqrt('value')"); }
            | SEN               { yyerrok; yyerror("Sintaxis -> sen('value')"); }
            | COS               { yyerrok; yyerror("Sintaxis -> os('value')"); }
            | TAN               { yyerrok; yyerror("Sintaxis -> tan('value')"); }
            | ASEN              { yyerrok; yyerror("Sintaxis -> asen('value')"); }
            | ACOS              { yyerrok; yyerror("Sintaxis -> acos('value')"); }
            | ATAN              { yyerrok; yyerror("Sintaxis -> atan('value')"); }
            | LOG10             { yyerrok; yyerror("Sintaxis -> log10('value')"); }
            | LOG               { yyerrok; yyerror("Sintaxis -> log('value')"); }
;

error_sep: '('
         | ')'
         | '(' ')'
         | '|'
         | '|' '|'
;

%%

void yyerror(char *s){
    printf("ERROR: %s \n", s);
    printf("----------------------------------------------------------------------------\n");
}

int main(int args, char **argv){
    yydebug = 0;
    printf("\t\t\t\tCALCULADORA\n");
    yyparse();
    return 0;
}

