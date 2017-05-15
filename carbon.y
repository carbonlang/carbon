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
%token STATIC

%token PTR CONST_PTR

%token DECIMAL_CONST

%error-verbose

%%

program
	: statements program
	| statements
	;

statements
	: declare_or_define
	;

declare_or_define
	: single_type_definition
	| array_type_definition
	| compound_type_declaration
	;

array_type_definition
	: single_type_definition '[' DECIMAL_CONST ']'		{ DEBUG("ARRAY"); }
	;

single_type_definition
	: basic_type_specifier IDENTIFIER			{ DEBUG("BASIC TYPE DEF"); }
	| compound_type_specifier IDENTIFIER			{ DEBUG("COMPOUND TYPE DEF"); }
	| type_prefix basic_type_specifier IDENTIFIER			{ DEBUG("BASIC TYPE DEF + TYPE PREFIX"); }
	| type_prefix compound_type_specifier IDENTIFIER		{ DEBUG("COMPOUND TYPE DEF + PREFIX"); }
	/* Pointers definition */
	| basic_type_specifier pointer IDENTIFIER			{ DEBUG("BASIC POINTER TYPE DEF"); }
	| compound_type_specifier pointer IDENTIFIER			{ DEBUG("COMPOUND POINTER TYPE DEF"); }
	| type_prefix basic_type_specifier pointer IDENTIFIER			{ DEBUG("BASIC POINTER TYPE DEF + TYPE PREFIX"); }
	| type_prefix compound_type_specifier pointer IDENTIFIER		{ DEBUG("COMPOUND POINTER TYPE DEF + PREFIX"); }
	;

compound_type_declaration
	: compound_type_specifier				{ DEBUG("COMPOUND TYPE DEC"); }
	| STRUCT IDENTIFIER					{ DEBUG("STRUCT VAR"); }
	| UNION IDENTIFIER					{ DEBUG("UNION VAR"); }
	| ENUM IDENTIFIER					{ DEBUG("ENUM VAR"); }
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
	: declare_or_define					{ DEBUG("STRUCT ELEMENT"); }
	| declare_or_define struct_declaration_list		{ DEBUG("STRUCT ELEMENT"); }
	;

union_specifier
	: UNION IDENTIFIER '{' union_declaration_list '}'
	| UNION '_' '{' union_declaration_list '}'
	;

union_declaration_list
	: declare_or_define					{ DEBUG("UNION ELEMENT"); }
	| declare_or_define union_declaration_list		{ DEBUG("UNION ELEMENT"); }
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

type_prefix
	: storage_class
	| type_qualifier
	| storage_class type_qualifier
	;

storage_class
	: STATIC				{ DEBUG("STATIC"); }
	;

type_qualifier
	: CONST					{ DEBUG("CONST"); }
	| VOLATILE				{ DEBUG("VOLATILE"); }
	| CONST VOLATILE			{ DEBUG("CONST VOLATILE"); }
	;

pointer
	: PTR pointer
	| CONST_PTR pointer
	| PTR
	| CONST_PTR
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
