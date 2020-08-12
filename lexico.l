%{
    #include "sintactico.tab.h"
%}

nombre_variable     [a-zA-Z]+([0-9]*|[a-zA-Z]*)*
valor_variable      [-]?[0-9]+([.]{1}[0-9]+)?

%%

"int"               { return(INT); }
"float"             { return(FLOAT); }
" "                 ;
"raiz"              { return(SQRT); }
"sen"               { return(SEN); }
"cos"               { return(COS); }
"tan"               { return(TAN); }
"ctg"               { return(COTAN); }
"sec"               { return(SEC); }
"csc"               { return(COSEC); }
"log"               { return(LOG); }
"asen"              { return(ASEN); }
"acos"              { return(ACOS); }
"atan"              { return(ATAN); }
{nombre_variable}   { yylval.nombre = strdup(yytext); return(ID); }
{valor_variable}    { yylval.valor = atof(yytext); return(NUM); }
.                   { return yytext[0]; }

%%

int yywrap(){
    return 0;
}

