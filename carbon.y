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
	: basic_type_specifier IDENTIFIER			{ DEBUG("BASIC DECLARATION FOUND"); }
	| compound_type_specifier				{ DEBUG("COMPOUND DECLARATION FOUND"); }
	| compound_type_specifier IDENTIFIER			{ DEBUG("COMPOUND DECLARATION WITH IDENT FOUND"); }
	| basic_type_specifier IDENTIFIER '[' DECIMAL_CONST ']'			{ DEBUG("BASIC ARRAY DECLARATION FOUND"); }
	| compound_type_specifier IDENTIFIER '[' DECIMAL_CONST ']'		{ DEBUG("COMPOUND ARRAY DECLARATION FOUND"); }
	;

basic_type_specifier
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

compound_type_specifier
	: struct_specifier		{ DEBUG("STRUCT FOUND"); }
	| union_specifier		{ DEBUG("UNION FOUND"); }
	| enum_specifier		{ DEBUG("ENUM FOUND"); }
	;

struct_specifier
	: STRUCT IDENTIFIER '{' struct_declaration_list '}'
	| STRUCT '_' '{' struct_declaration_list '}'
	;

struct_declaration_list
	: declaration_specifier					{ DEBUG("STRUCT ELEMENT"); }
	| declaration_specifier struct_declaration_list		{ DEBUG("STRUCT ELEMENT"); }
	;

union_specifier
	: UNION IDENTIFIER '{' union_declaration_list '}'
	| UNION '_' '{' union_declaration_list '}'
	;

union_declaration_list
	: declaration_specifier					{ DEBUG("UNION ELEMENT"); }
	| declaration_specifier union_declaration_list		{ DEBUG("UNION ELEMENT"); }
	;

enum_specifier
	: ENUM IDENTIFIER '{' enum_declaration_list '}'
	| ENUM '_' '{' enum_declaration_list '}'
	;

enum_declaration_list
	: IDENTIFIER						{ DEBUG("ENUM ELEMENT"); }
	| IDENTIFIER '=' DECIMAL_CONST				{ DEBUG("ENUM ELEMENT = VALUE"); }
	| IDENTIFIER enum_declaration_list			{ DEBUG("ENUM ELEMENT"); }
	| IDENTIFIER '=' DECIMAL_CONST enum_declaration_list	{ DEBUG("ENUM ELEMENT = VALUE"); }
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
