%{
#include <string>

%}

ESPACO [ \t]
DIGITO [0-9]
LETRA [A-Za-z_]
BOOL True|False

DELIM {ESPACO}+
NUM {DIGITO}+
REAL {NUM}+("."{NUM}+)?
CHAR \"({LETRA}|{NUM})\"
ID {LETRA}({LETRA}|{NUM})*
STRING \"(({LETRA}({LETRA}|{NUM})*)|{LETRA}*)\"

%%

"\n"		{}

{DELIM} 	{}

"main"		{return TK_MAIN;}

"int"		{yylval.label = yytext; return TK_TIPO_INT;}

"float"		{yylval.label = yytext; return TK_TIPO_FLOAT;}

"char"		{yylval.label = yytext; return TK_TIPO_CHAR;}

"bool"		{yylval.label = yytext; return TK_TIPO_BOOL;}

"String"	{yylval.label = yytext; return TK_TIPO_STRING;}


[(){}[\];,]	{ return *yytext; }

[+\-*=/!]	{ return *yytext; }

"<"			{ return TK_OP_LESSER; }
"<="		{ return TK_OP_LESSER_EQUAL; }
">"			{ return TK_OP_EQUAL; }
">="		{ return TK_OP_GREATER; }
"=="		{ return TK_OP_GREATER_EQUAL; }
"!="		{ return TK_OP_DIFERENT; }

{BOOL}		{ yylval.value = yytext; return TK_BOOL; }
{NUM}		{ yylval.value = yytext; return TK_NUM; }
{REAL}		{ yylval.value = yytext; return TK_REAL; }
{CHAR}		{ yylval.value = yytext; return TK_CHAR;}
{STRING}	{ yylval.value = yytext; return TK_STRING;}
{ID}		{ yylval.name = yytext; return TK_ID; }

.			{ *yytext; }

%%

int yywrap(void)
{
	return 1;
}
