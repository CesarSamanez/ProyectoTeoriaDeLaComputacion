%{
    #include "sintactico.tab.h"
%}

numero              [0-9]+("."[0-9]+)?

%%

{numero}            { yylval.valor=atof(yytext); return(NUM); }
" "                 ;
"raiz"              { return(SQRT); }
"sen"               { return(SEN); }
"cos"               { return(COS); }
"tan"               { return(TAN); }
"ctg"               { return(COTAN); }
"sec"               { return(SEC); }
"csc"               { return(COSEC); }
"log"               { return(LOG); }
"asin"              { return(ASEN); }
"acos"              { return(ACOS); }
"atan"              { return(ATAN); }
\n                  { return(EOL); }
.                   { return yytext[0]; }


%%

int yywrap(){
    return 0;
}