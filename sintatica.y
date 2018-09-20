//%name parse

%{
#include <iostream>
#include <vector>
#include <string>
#include <sstream>

//#include "tabelin.h"

#define YYSTYPE $atributos

using namespace std;

typedef struct $atributos
{
	string label;
	string traducao;
	string name;
	string type;
	string value;
}ATRIBUTOS;

vector<ATRIBUTOS> table;

int yylex(void);
void yyerror(string);
string gentemp();
void insertTable(string type, string name, string value, string temp);
int existe(string name);
ATRIBUTOS buscaTable(int index);

%}
%token TK_NUM TK_REAL TK_CHAR TK_STRING TK_BOOL
%token TK_OP_LESSER TK_OP_LESSER_EQUAL TK_OP_EQUAL TK_OP_GREATER TK_OP_GREATER_EQUAL TK_OP_DIFERENT
%token TK_MAIN TK_ID TK_TIPO_INT TK_TIPO_FLOAT TK_TIPO_CHAR TK_TIPO_STRING TK_TIPO_BOOL
%token TK_FIM TK_ERROR
%start S
%left '='
%left TK_OP_LESSER TK_OP_LESSER_EQUAL TK_OP_EQUAL TK_OP_GREATER TK_OP_GREATER_EQUAL TK_OP_DIFERENT
%left '+' '-'
%left '*' '/'

%%
S 			: TK_TIPO_INT TK_MAIN '(' ')' BLOCO
			{
				cout << "/*Compilaaaator*/\n" << "#include <iostream>\n#include<string.h>\n#include<metacoisas.h>\nint main(void)\n{\n" << $5.traducao << "\treturn 0;\n}" << endl; 
			}
			;

BLOCO		: '{' COMANDOS '}'
			{
				$$.traducao = $2.traducao;
			}
			;

COMANDOS	: COMANDOS COMANDO
			{
				$$.traducao = $1.traducao + $2.traducao;
			}
			|
			{
				$$.traducao = "";
			}
			;

COMANDO 	: E ';'
			{
				$$.traducao = $1.traducao;
			}
			| R ';'
			{
				$$.traducao = $1.traducao;
			}
			| D ';'
			{
				$$.traducao = $1.traducao;
			}
			| A ';'
			{
				$$.traducao = $1.traducao;
			}		
			;

TIPO 		: TK_TIPO_INT
			{
				$$ = $1;
			}
			| TK_TIPO_FLOAT
			{
				$$ = $1;
			}
			| TK_TIPO_BOOL
			{
				$$ = $1;
			}
			| TK_TIPO_CHAR
			{
				$$ = $1;
			}
			| TK_TIPO_STRING
			{
				$$ = $1;
			}
			;


D 			: TIPO TK_ID
			{
				if(existe($2.name) < 0)
				{
					$2.label = gentemp();
					insertTable($1.label, $2.name, $2.value, $2.label);
					$$.traducao = "\t" + $1.label + " " + $2.label + ";\n";//+ " = " + $1.value + ";\n";
				}
				else
				{
					cout << "Erro: Variavel já declarada!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n";
					exit(1);
				}
			}
			;

A 			: TK_ID '=' E
			{
				int index;
				if((index = existe($1.name)) >= 0)
				{
					ATRIBUTOS aux = buscaTable(index);
					$$.name = aux.name;
					$$.type = aux.type;
					$$.value = aux.value;
					$$.label = aux.label;

					if ($$.type == $3.type)
					{
						$$.traducao = $3.traducao + "\t" + $$.label + " = " + $3.label + "\n";
					}
					else
					{
						cout << "Conflito de atribuicao: ( " + $$.type + " )" + " != " + "( " + $3.type + " )\n";
						exit(1);	
					}
				}
				else
				{
					cout << "Erro: Variavel naaaaaaaaaaaaoooooooooooo declarada!\n";
					exit(1);
				}
			}
 			;

E 			: E '+' E
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + "+" + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos na soma, tentando fazer: ( " + $1.type + " )" + " + " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| E '-' E
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + "-" + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos na subtracao, tentando fazer: ( " + $1.type + " )" + " - " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| E '*' E
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + "*" + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos na multiplicacao, tentando fazer: ( " + $1.type + " )" + " * " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| E '/' E
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + "/" + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos na soma, tentando fazer: ( " + $1.type + " )" + " / " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| VAR
			;

R 			: R TK_OP_LESSER R
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " < " + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos em comparacao, tentando fazer: ( " + $1.type + " )" + " < " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| R TK_OP_LESSER_EQUAL R
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " <= " + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos em comparacao, tentando fazer: ( " + $1.type + " )" + " <= " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| R TK_OP_GREATER R
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " > " + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos em comparacao, tentando fazer: ( " + $1.type + " )" + " > " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| R TK_OP_GREATER_EQUAL R
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " >= " + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos em comparacao, tentando fazer: ( " + $1.type + " )" + " >= " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| R TK_OP_EQUAL R
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " == " + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos em comparacao, tentando fazer: ( " + $1.type + " )" + " == " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| R TK_OP_DIFERENT R
			{
				if ($1.type == $3.type)
				{
					$$.type = $1.type;
					$$.label = gentemp();
					$$.traducao = $1.traducao + $3.traducao + "\t" + $$.label + " = " + $1.label + " != " + $3.label + ";\n";
				}
				else
				{
					cout << "Conflito de tipos em comparacao, tentando fazer: ( " + $1.type + " )" + " != " + "( " + $3.type + " )\n";
					exit(1);
				}
			}
			| E
			{
				$$ = $1;
			}
			;

VAR 		: TK_NUM
			{
				$$.type = "int";
				$$.label = gentemp();
				$$.value = $1.value;
				$$.traducao = "\t" + $$.label + " = " + $1.value + ";\n";			
			}
			| TK_REAL
			{
				$$.type = "float";
				$$.label = gentemp();
				$$.value = $1.value;
				$$.traducao = "\t" + $$.label + " = " + $1.value + ";\n";			
			}
			| TK_BOOL
			{
				$$.type = "bool";
				$$.label = gentemp();
				$$.value = $1.value;
				$$.traducao = "\t" + $$.label + " = " + $1.value + ";\n";
			}
			| TK_CHAR
			{
				$$.type = "char";
				$$.label = gentemp();
				$$.value = $1.value;
				$$.traducao = "\t" + $$.label + " = " + $1.value + ";\n";	
			}
			| TK_STRING
			{
				$$.type = "String";
				$$.label = gentemp();
				$$.value = $1.value;
				$$.traducao = "\t" + $$.label + " = " + $1.value + ";\n";			
			}
			| TK_ID
			{
				int index;
				if((index = existe($1.name)) >= 0)
				{
					ATRIBUTOS aux = buscaTable(index);
					$$.name = aux.name;
					$$.type = aux.type;
					$$.value = aux.value;
					$$.label = aux.label;
					$$.traducao = "\t" + $$.label + " = " + $1.value + ";\n";
				}
				else
				{
					cout << "Erro: Variavel naaaaaaaaaaaaoooooooooooo declarada!\n";
					exit(1);
				}
			}
			;

%%

#include "lex.yy.c"


void insertTable(string type, string name, string value, string temp)
{
	ATRIBUTOS aux;

	aux.type = type;
	aux.name = name;
	aux.value = value;
	aux.label = temp;

	table.push_back(aux);
}

int existe(string name)
{
	for (int i = 0; i < table.size(); ++i)
	{
		if (name == table[i].name)
		{
			return i;
		}
	}
	return -1;
}

ATRIBUTOS buscaTable(int index)
{
	return table[index];
}

string gentemp()
{
	static int tempNum = 0;
	tempNum++;
	return "TMP" + to_string(tempNum);
}

int yyparse();

int main( int argc, char* argv[] )
{
	yyparse();
	return 0;
}

void yyerror( string MSG )
{
	cout << MSG << endl;
	exit (0);
}				