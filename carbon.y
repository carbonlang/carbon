%{
#include <stdio.h>
#define DEBUG(s) printf("PARSER: " s "\n");
%}

/* Declare tokens */
%token IDENTIFIER
%token CHAR STRING
%token BOOL
%token INT UINT INT8 INT16 INT32 INT64 UINT8 UINT16 UINT32 UINT64
%token FLOAT32 FLOAT64 FLOAT128
%token STRUCT UNION ENUM

%token TRUE FALSE

%token CONST VOLATILE
%token STATIC

%token PTR CONST_PTR

%token BINARY_CONST OCTAL_CONST DECIMAL_CONST HEX_CONST FLOAT_CONST
%token CHAR_LITERAL STRING_LITERAL

%error-verbose

%%

program
	: statements program
	| statements
	;

statements
	: declare_or_define
	| initialize
	;

declare_or_define
	: single_type_definition
	| array_type_definition
	| compound_type_declaration
	;

initialize
	: single_type_definition initializer
	| array_type_definition initializer
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

basic_type_specifier
	: CHAR
	| STRING
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

compound_type_declaration
	: STRUCT IDENTIFIER '{' struct_declaration_list '}'
	| UNION IDENTIFIER '{' union_declaration_list '}'
	| ENUM IDENTIFIER '{' enum_declaration_list '}'
	;

struct_specifier
	: STRUCT IDENTIFIER '{' struct_declaration_list '}'
	| STRUCT '_' '{' struct_declaration_list '}'
	| STRUCT IDENTIFIER
	;

struct_declaration_list
	: declare_or_define					{ DEBUG("STRUCT ELEMENT"); }
	| declare_or_define struct_declaration_list		{ DEBUG("STRUCT ELEMENT"); }
	;

union_specifier
	: UNION IDENTIFIER '{' union_declaration_list '}'
	| UNION '_' '{' union_declaration_list '}'
	| UNION IDENTIFIER
	;

union_declaration_list
	: declare_or_define					{ DEBUG("UNION ELEMENT"); }
	| declare_or_define union_declaration_list		{ DEBUG("UNION ELEMENT"); }
	;

enum_specifier
	: ENUM IDENTIFIER '{' enum_declaration_list '}'
	| ENUM '_' '{' enum_declaration_list '}'
	| ENUM IDENTIFIER
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

initializer
	: '=' init_exp				{ DEBUG("INIT"); }
	| '=' '{' init_list '}'			{ DEBUG("INIT LIST"); }
	;

init_list
	: init_exp
	| init_exp ',' init_list
	;

init_exp
	: OCTAL_CONST
	| DECIMAL_CONST
	| HEX_CONST
	| FLOAT_CONST
	| CHAR_LITERAL
	| STRING_LITERAL
	| IDENTIFIER
	| TRUE
	| FALSE
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
