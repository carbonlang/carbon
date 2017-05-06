%{
#include <stdio.h>
#define DEBUG(s) printf("PARSER: " s "\n");
%}

/* Declare tokens */
%token IDENTIFIER
%token CHAR BOOL
%token INT UINT INT8 INT16 INT32 INT64 UINT8 UINT16 UINT32 UINT64
%token FLOAT32 FLOAT64 FLOAT128
%token STRUCT UNION ENUM

%token CONST VOLATILE

%token DECIMAL_CONST

%error-verbose

%%

program
	: declaration_specifier program
	| declaration_specifier
	;

declaration_specifier
	: basictype_specifier IDENTIFIER '[' DECIMAL_CONST ']'	{ DEBUG("ARRAY DECLARATION FOUND!"); }
	| basictype_specifier IDENTIFIER			{ DEBUG("BASIC DECLARATION FOUND!"); }
	| STRUCT IDENTIFIER '{' struct_declaration_list '}'	{ DEBUG("STRUCT DECLARATION FOUND!"); }
	| UNION IDENTIFIER '{' union_declaration_list '}'	{ DEBUG("UNION DECLARATION FOUND!"); }
	| ENUM IDENTIFIER '{' enumerator_list '}'		{ DEBUG("ENUM DECLARATION FOUND!"); }
	;

basictype_specifier
	: CHAR
	| BOOL
	| INT
	| UINT
	| INT8
	| INT16
	| INT32
	| INT64
	| UINT8
	| UINT16
	| UINT32
	| UINT64
	| FLOAT32
	| FLOAT64
	| FLOAT128
	;

struct_declaration_list
	: declaration_specifier					{ DEBUG("STRUCT ELEMENT"); }
	| declaration_specifier struct_declaration_list
	;

union_declaration_list
	: declaration_specifier					{ DEBUG("UNION ELEMENT"); }
	| declaration_specifier union_declaration_list
	;

enumerator_list
	: IDENTIFIER						{ DEBUG("UNION ELEMENT"); }
	| IDENTIFIER '=' DECIMAL_CONST				{ DEBUG("UNION ELEMENT = VALUE"); }
	| IDENTIFIER enumerator_list
	| IDENTIFIER '=' DECIMAL_CONST enumerator_list
	;

%%

int main(int argc, char *argv[]) {
	yyparse();
	return 0;
}

int yyerror(char *s) {
	fprintf(stderr, "PARSE ERROR: %s\n", s);
	return 0;
}
