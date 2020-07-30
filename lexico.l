%{
    #include "sintactico.tab.h"
%}

numero              [0-9]+("."[0-9]+)?

%%

{numero}            { yylval.valor=atof(yytext); return(NUM); }
" "                 ;
\n                  { return(EOL); }
.                   { return yytext[0]; }
"sqrt"              { return(SQRT); }
"sen"               { return(SEN); }
"cos"               { return(COS); }
"tan"               { return(TAN); }
"log10"             { return(LOG10); }
"log"               { return(LOG); }
"asin"              { return(ASEN); }
"acos"              { return(ACOS); }
"atan"              { return(ATAN); }


%%

int yywrap(){
    return 0;
}