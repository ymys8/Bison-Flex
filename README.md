# Проект анализатора Bison + Flex для выражений  из оператора 'class'. 
Пример: class Test {public int x; private int y; Test z;};
## Используемая грамматика:
**NAME** – произвольный набор символов латиницы, где цифры могут идти только после букв

**VAR** – буква латинского алфавита

**TYPE** – тип переменной языка c++(int, bool, float, double, char)

sentences ::= class_declaration

class_declaration ::= class end class_declaration | λ

class ::= "class" NAME

end ::= ; | {content};

content ::= private_block declaration_block content | λ

private_block ::= private | public | protected | λ

declaration_block ::= type VAR;

type ::= NAME | TYPE

## Сборка:
1. Написать команду:
> make first
2. После генерации файлов .c зайти в файл grammar.tab.h и заменить 
> typedef int YYSTYPE;

На:
> typedef char* YYSTYPE;

Так как для семантического вывода используется строковое значение токенов
3. Написать команду:
> make
4. Запустить программу:
> make run

## Правила ввода предложения
Можно вводить любой набор символов, но после ввода символа новой строки предложение считается законченным.
