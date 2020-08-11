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
%token EOL 

%left '-' '+'
%left '*' '/' 
%right '^' 
%left SEN COS TAN COTAN SEC COSEC ASEN ACOS ATAN LOG MOD SQRT

%type <valor> exp

%%

stm_lst: stm EOL
        |stm_lst stm EOL
        |stm_lst error EOL  {yyerrok;}
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
        |SQRT  exp          { 
                                if($2 < 0){
                                    $$ = -1;
                                    yyerrok;
                                    yyerror("Raiz de número negativo");
                                }else{
                                    $$ = sqrt($2);
                                } 
                            }                                      /* Raiz cuadrada */
        |SEN  exp           { $$ = sin($2 / 180 * PI); }           /* Funcion seno */
        |COS  exp           { $$ = cos($2 / 180 * PI); }           /* Funcion coseno */
        |TAN  exp           { $$ = tan($2 / 180 * PI); }           /* Funcion tangente */
        |COSEC  exp         { $$ = 1/sin($2 / 180 * PI); }         /* Funcion cosecante */
        |SEC  exp           { $$ = 1/cos($2 / 180 * PI); }         /* Funcion secante */
        |COTAN  exp         { $$ = 1/tan($2 / 180 * PI); }         /* Funcion cotangente */
        |ASEN  exp          { 
                                if($2 >= -1 && $2 <= 1){
                                    $$ = asin($2);
                                }else{
                                    $$ = -1;
                                    yyerrok;
                                    yyerror("El dominio para arcsen(x) es -1 <= x <= 1");
                                }
                            }                                       /* Funcion arco_seno */
        |ACOS  exp          { 
                                if($2 >= -1 && $2 <= 1){
                                    $$ = acos($2);
                                }else{
                                    $$ = -1;
                                    yyerrok;
                                    yyerror("El dominio para arccos(x) es -1 <= x <= 1");
                                }
                            }                                       /* Funcion arco_coseno */
        |ATAN  exp          { $$ = atan($2); }                      /* Funcion arco_tangente */
        |LOG  exp           { $$ = log10($2); }                     /* Logaritmo base 10 */
        |'|' exp '|'        { $$ = abs($2); }                       /* Valor absoluto */
        |'(' exp ')'        { $$ = $2; }                            /* Reconocimiento agrupaciones por '()' */               
        |'(' error ')'      { yyerrok; }
        |exp operaciones    { $$ = $1; yyerrok; }        
;

operaciones: '+'
            |'-'
            |'*'
            |'/'
            |'%'
            |SQRT
            |SEN
            |COS
            |TAN
            |COSEC
            |SEC
            |COTAN
            |ASEN
            |ACOS
            |ATAN
            |LOG
            |'|'
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

