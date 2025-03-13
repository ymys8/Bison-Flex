%{
#include <stdio.h>
#include <string.h>

#define MAX_VARS 100
#define MAX_CLASSES 10

typedef struct
{
    const char* type;
    const char* name;
    const char* visibility;
} Variable;

typedef struct
{
    const char* name;
    Variable vars[MAX_VARS];
    int var_count;
} ClassInfo;

ClassInfo classes[MAX_CLASSES];
int class_count = 0;

int yylex(void);
void yyerror(const char* s) 
{
    fprintf(stderr, "Ошибка: %s\n", s);
}
void printInfo()
{
    for (int i = 0; i < class_count; i++) 
    {
        printf("Декларация класса: %s\n", classes[i].name);
        for (int j = 0; j < classes[i].var_count; j++) 
        {
            printf("Переменная: %s %s (область видимости: %s)\n",
                   classes[i].vars[j].type,
                   classes[i].vars[j].name,
                   classes[i].vars[j].visibility);
        }
    }
}
bool findName(const char* type)
{
    for (int i = 0; i < class_count; i++) 
    {
        if (strcmp(classes[i].name, type) == 0) 
        {
            return true;
        }
    }
    return false;
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

%%
sentences           :   class_declaration { printInfo(); printf("Обработка завершена успешно\n"); }
                    ;
class_declaration   :   class end class_declaration
                    |
                    ;
class               :   CLASS NAME { 
                            ClassInfo* new_class = &classes[class_count++];
                            new_class->name = strdup($2);
                            new_class->var_count = 0;
                        }
                    ;
end                 :   SEMICOLON
                    |   RBRACE content LBRACE_SEM
                    ;
content             :   private_block declaration_block content
                    |
                    ;
private_block       :   PRIVATE { 
                        classes[class_count - 1].vars[classes[class_count - 1].var_count].visibility = "private"; 
                        }
                    |   PUBLIC { 
                        classes[class_count - 1].vars[classes[class_count - 1].var_count].visibility = "public"; 
                        }
                    |   PROTECTED { 
                        classes[class_count - 1].vars[classes[class_count - 1].var_count].visibility = "protected"; 
                        }
                    |   { classes[class_count - 1].vars[classes[class_count - 1].var_count].visibility = "None"; }
                    ;
declaration_block   :   type VAR SEMICOLON { 
                            ClassInfo* current_class = &classes[class_count - 1];
                            current_class->vars[current_class->var_count].type = strdup($1);
                            current_class->vars[current_class->var_count].name = strdup($2);
                            current_class->var_count++; 
                        }
                    ;
type                :   NAME {
                            if (!findName(strdup($1)))
                            {
                                yyerror("Тип переменной не определен\n");
                                exit(1);
                            }
                        }
                    |   TYPE
                    ;
%%

int main(int argc, char** argv)
{
    return yyparse();
}
