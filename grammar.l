%option noyywrap

%{

#include <stdio.h>

#define YY_DECL int yylex()

#include "grammar.tab.h"

%}

%%
"private"                                           {return PRIVATE;}
"public"                                            {return PUBLIC;}
"protected"                                         {return PROTECTED;}
"int"|"char"|"bool"|"float"|"double"                {yylval = strdup(yytext);return TYPE;}
"class"                                             {return CLASS;}
";"                                                 {return SEMICOLON;}
\{                                                  {return RBRACE;}
\}";"                                               {return LBRACE_SEM;}
[A-Za-z][A-Za-z0-9_]+                               {yylval = strdup(yytext); return NAME;}
[A-Za-z]                                            {yylval = strdup(yytext); return VAR;}
"\n"                                                {printf("Конец предложения\n"); return EOS;}
[ \t]+                                              {}
.                                                   {}
%%