%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #define YYDEBUG 1
    #define PI 3.14159265
    extern int yylex(void);
    extern char *yytext;
    extern FILE *yyin;
    void yyerror(char*);

    int numero_operacion = 1;
%}

%union{
    double valor;
}

%token <valor> NUM
%token EOL SQRT
%token SEN COS TAN COTAN SEC COSEC ASEN ACOS ATAN LOG

%left '-' '+'
%left '*' '/' 
%right '^'

%type <valor> exp

%%

stm_lst: stm EOL
        |stm_lst stm EOL
;

stm: exp {
            if($1 == -1){
                printf("Expresión nro.%d, no tiene solución.\n", numero_operacion);
                printf("----------------------------------------------------------------------------\n\n");
                numero_operacion++;
            }else{
                printf("Expresión nro.%d\n", numero_operacion);
                printf("Resultado = %.2f\n\n", $1);
                numero_operacion++;
            }
         }
;

exp:    NUM                 { $$ = $1; }                /* Detecta un numero */
        |'-' NUM            { $$ = -1 * $2; }           /* Numero negativo */
        |exp '+' exp        { $$ = $1 + $3; }           /* Suma */
        |exp '-' exp        { $$ = $1 - $3; }           /* Resta */
        |exp '*' exp        { $$ = $1 * $3; }           /* Multiplicación */
        |exp '/' exp        {   
                                if($3 != 0){            /* Verificacion errores division por 0 */
                                    $$ = $1 / $3;
                                }else{
                                    $$ = -1;
                                    yyerrok;
                                    yyerror("No existe división entre cero");
                                }
                            }                           /* División */
        |exp '%' exp        { 
                                if($3 <= 0){
                                    $$ = -1;
                                    yyerrok;
                                    yyerror("El valor debe ser mayor a 0");
                                }else{
                                    $$ = fmod($1, $3);
                                } 
                            }      /* Modulo de un numero */
        |exp '^' exp        { 
                                if($3 == 0){
                                    $$ = 1;
                                }else{
                                    $$ = pow($1, $3);
                                }
                            }       /* Potencia */
        |SQRT '(' exp ')'   { 
                                if($3 < 0){
                                    $$ = -1;
                                    yyerrok;
                                    yyerror("Raiz de número negativo");
                                }else{
                                    $$ = sqrt($3);
                                } 
                            }                                      /* Raiz cuadrada */
        |SEN '(' exp ')'    { $$ = sin($3 / 180 * PI); }           /* Funcion seno */
        |COS '(' exp ')'    { $$ = cos($3 / 180 * PI); }           /* Funcion coseno */
        |TAN '(' exp ')'    { $$ = tan($3 / 180 * PI); }           /* Funcion tangente */
        |COSEC '(' exp ')'  { $$ = 1/sin($3 / 180 * PI); }         /* Funcion cosecante */
        |SEC '(' exp ')'    { $$ = 1/cos($3 / 180 * PI); }         /* Funcion secante */
        |COTAN '(' exp ')'  { $$ = 1/tan($3 / 180 * PI); }         /* Funcion cotangente */
        |ASEN '(' exp ')'   { 
                                if($3 >= -1 && $3 <= 1){
                                    $$ = asin($3);
                                }else{
                                    $$ = -1;
                                    yyerrok;
                                    yyerror("El dominio para arcsen(x) es -1 <= x <= 1");
                                }
                            }                                       /* Funcion arco_seno */
        |ACOS '(' exp ')'   { 
                                if($3 >= -1 && $3 <= 1){
                                    $$ = acos($3);
                                }else{
                                    $$ = -1;
                                    yyerrok;
                                    yyerror("El dominio para arccos(x) es -1 <= x <= 1");
                                }
                            }                                       /* Funcion arco_coseno */
        |ATAN '(' exp ')'   { $$ = atan($3); }                      /* Funcion arco_tangente */
        |LOG '(' exp ')'    { $$ = log10($3); }                     /* Logaritmo base 10 */
        |'|' exp '|'        { $$ = abs($2); }                       /* Valor absoluto */
        |'(' exp ')'        { $$ = $2; }                            /* Reconocimiento agrupaciones por '()' */
        |exp '+'            { $$ = $1; yyerrok; }           
        |exp '-'            { $$ = $1; yyerrok; }           
        |exp '*'            { $$ = $1; yyerrok; }           
        |exp '/'            { $$ = $1; yyerrok; }                           
        |exp '%'            { $$ = $1; yyerrok; }      
        |exp '^'            { $$ = $1; yyerrok; }       
;

%%

void yyerror(char *s){
    printf("----------------------------------------------------------------------------\n");
    printf("ERROR: %s \n", s);
}

int main(int args, char **argv){
    yydebug = 0;
    printf("\n---------------------------- CALCULADORA -----------------------------------\n");

    if(args>1)
        yyin=fopen(argv[1], "rt");
    else
        yyin=fopen("operaciones.txt","rt");
   
    yyparse();
    return 0;
}

