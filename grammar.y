%{
#include <stdio.h>
#include <string.h>

int yylex(void);
void yyerror(const char* s) 
{
    fprintf(stderr, "Ошибка: %s\n", s);
}
%}

%token NAME
%token VAR
%token TYPE
%token SEMICOLON
%token RBRACE
%token LBRACE_SEM
%token PRIVATE
%token PUBLIC
%token PROTECTED
%token CLASS
%token EOS

%%
sentences           :   class_declaration 
                    ;
class_declaration   :   class end class_declaration EOS
                    |
                    ;
class               :   CLASS NAME { printf("Декларация класса: %s\n", $2); }
                    ;
end                 :   SEMICOLON
                    |   RBRACE content LBRACE_SEM
                    ;
content             :   private_block declaration_block content
                    |
                    ;
private_block       :   PRIVATE { printf("Переменная имеет область видимости private\n"); }
                    |   PUBLIC { printf("Переменная имеет область видимости public\n"); }
                    |   PROTECTED { printf("Переменная имеет область видимости protected\n"); }
                    |   {printf("Область видимости не задана\n");}
                    ;
declaration_block   :   type VAR SEMICOLON { printf("Объявление переменной: %s %s\n", $1, $2); }
                    ;
type                :   NAME
                    |   TYPE
                    ;
%%

int main(int argc, char** argv)
{
    return yyparse();
}
