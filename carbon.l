BINARY		[0-1]
OCTAL		[0-7]
DECIMAL		[0-9]
HEX		[a-fA-F0-9]
BINARY_PREFIX	"2#"
OCTAL_PREFIX	"8#"
DECIMAL_PREFIX	"10#"
HEX_PREFIX	"16#"

E_EXP		([Ee][+-]?{DECIMAL}+)
P_EXP		([Pp][+-]?{DECIMAL}+)

ALPHA		[a-zA-Z_0-9]
FIRST_ALPHA	[a-zA-Z_]

%{

#include "carbon.tab.h"
extern FILE *yyin;
void comment(void);
#define DEBUG(s) printf("LEXER: " s "\n");

%}

%%

"/*"		{ comment(); }
"//".*		{ DEBUG("Single line comment"); /* consume single line comment */ }

asm		{ DEBUG("ASM"); }
assert		{ DEBUG("ASSERT"); }
auto		{ DEBUG("AUTO"); }
bool		{ DEBUG("BOOL"); return BOOL; }
break		{ DEBUG("BREAK"); }
case		{ DEBUG("CASE"); }
char		{ DEBUG("CHAR"); return CHAR; }
const		{ DEBUG("CONST"); return CONST; }
const_ptr	{ DEBUG("CONST_PTR"); return CONST_PTR; }
continue	{ DEBUG("CONTINUE"); }
default		{ DEBUG("DEFAULT"); }
defer		{ DEBUG("DEFER"); }
delete		{ DEBUG("DELETE"); }
do		{ DEBUG("DO"); }
else		{ DEBUG("ELSE"); }
enum		{ DEBUG("ENUM"); return ENUM; }
false		{ DEBUG("FALSE"); return FALSE; }
float32		{ DEBUG("FLOAT32"); return FLOAT32; }
float64		{ DEBUG("FLOAT64"); return FLOAT64; }
float128	{ DEBUG("FLOAT128"); return FLOAT128; }
for		{ DEBUG("FOR"); }
foreach		{ DEBUG("FOREACH"); }
func		{ DEBUG("FUNC"); }
goto		{ DEBUG("GOTO"); }
if		{ DEBUG("IF"); }
in		{ DEBUG("IN"); }
include		{ DEBUG("INCLUDE"); }
int		{ DEBUG("INT"); return INT; }
int8		{ DEBUG("INT8"); return INT8; }
int16		{ DEBUG("INT16"); return INT16; }
int32		{ DEBUG("INT32"); return INT32; }
int64		{ DEBUG("INT64"); return INT64; }
len		{ DEBUG("LEN"); }
module		{ DEBUG("MODULE"); }
new		{ DEBUG("NEW"); }
ptr		{ DEBUG("PTR"); return PTR; }
ref		{ DEBUG("REF"); }
return		{ DEBUG("RETURN"); }
sizeof		{ DEBUG("SIZEOF"); }
static		{ DEBUG("STATIC"); return STATIC; }
static_assert	{ DEBUG("STATIC_ASSERT"); }
string		{ DEBUG("STRING"); return STRING; }
struct		{ DEBUG("STRUCT"); return STRUCT; }
switch		{ DEBUG("SWITCH"); }
true		{ DEBUG("TRUE"); return TRUE; }
type		{ DEBUG("TYPE"); }
volatile	{ DEBUG("VOLATILE"); return VOLATILE; }
uint		{ DEBUG("UINT"); return UINT; }
uint8		{ DEBUG("UINT8"); return UINT8; }
uint16		{ DEBUG("UINT16"); return UINT16; }
uint32		{ DEBUG("UINT32"); return UINT32; }
uint64		{ DEBUG("UINT64"); return UINT64; }
union		{ DEBUG("UNION"); return UNION; }
use		{ DEBUG("USE"); }
while		{ DEBUG("WHILE"); }

"_"		{ DEBUG("_"); return '_'; }

[a-zA-Z_][a-zA-Z_0-9]*		{ DEBUG("IDENTIFIER"); return IDENTIFIER; }

{BINARY_PREFIX}{BINARY}+	{ DEBUG("BINARY CONSTANT"); return BINARY_CONST; }
{OCTAL_PREFIX}{OCTAL}+		{ DEBUG("OCTAL CONSTANT"); return OCTAL_CONST; }
{DECIMAL_PREFIX}?{DECIMAL}+	{ DEBUG("DECIMAL CONSTANT"); return DECIMAL_CONST; }
{HEX_PREFIX}{HEX}+		{ DEBUG("HEX CONSTANT"); return HEX_CONST; }

{DECIMAL}+{E_EXP}			{ DEBUG("CLASS A FLOAT CONSTANT"); return FLOAT_CONST; }
{DECIMAL}*"."{DECIMAL}+{E_EXP}?		{ DEBUG("CLASS B FLOAT CONSTANT"); return FLOAT_CONST; }
{DECIMAL}+"."{E_EXP}?			{ DEBUG("CLASS C FLOAT CONSTANT"); return FLOAT_CONST; }
{HEX_PREFIX}{HEX}+{P_EXP}		{ DEBUG("CLASS D FLOAT CONSTANT"); return FLOAT_CONST; }
{HEX_PREFIX}{HEX}*"."{HEX}+{P_EXP}	{ DEBUG("CLASS E FLOAT CONSTANT"); return FLOAT_CONST; }
{HEX_PREFIX}{HEX}+"."{P_EXP}		{ DEBUG("CLASS F FLOAT CONSTANT"); return FLOAT_CONST; }

"&^"		{ DEBUG("AND_NOT_OP"); return AND_NOT_OP; }
"<<"		{ DEBUG("RS_OP"); return RS_OP; }
">>"		{ DEBUG("LS_OP"); return LS_OP; }
"=="		{ DEBUG("EQ_OP"); return EQ_OP; }
"!="		{ DEBUG("NE_OP"); return NE_OP; }
"<="		{ DEBUG("LE_OP"); return LE_OP; }
">="		{ DEBUG("GE_OP"); return GE_OP; }
"&&"		{ DEBUG("AND_OP"); return AND_OP; }
"||"		{ DEBUG("OR_OP"); return OR_OP; }
"++"		{ DEBUG("INC_OP"); return INC_OP; }
"--"		{ DEBUG("DEC_OP"); return DEC_OP; }
"+="		{ DEBUG("ADD_ASSIGN_OP"); return ADD_ASSIGN_OP; }
"-="		{ DEBUG("SUB_ASSIGN_OP"); return SUB_ASSIGN_OP; }
"*="		{ DEBUG("MUL_ASSIGN_OP"); return MUL_ASSIGN_OP; }
"/="		{ DEBUG("DIV_ASSIGN_OP"); return DIV_ASSIGN_OP; }
"%="		{ DEBUG("MOD_ASSIGN_OP"); return MOD_ASSIGN_OP; }
"&="		{ DEBUG("AND_ASSIGN_OP"); return AND_ASSIGN_OP; }
"|="		{ DEBUG("OR_ASSIGN_OP"); return OR_ASSIGN_OP; }
"^="		{ DEBUG("XOR_ASSIGN_OP"); return XOR_ASSIGN_OP; }
"&^="		{ DEBUG("AND_NOT_ASSIGN_OP"); return AND_NOT_ASSIGN_OP; }
">>="		{ DEBUG("LS_ASSIGN_OP"); return LS_ASSIGN_OP; }
"<<="		{ DEBUG("RS_ASSIGN_OP"); return RS_ASSIGN_OP; }
"->"		{ DEBUG("MINUS_GR_OP"); }

"="		{ DEBUG("="); return '='; }
"+"		{ DEBUG("+"); return '+'; }
"-"		{ DEBUG("-"); return '-'; }
"*"		{ DEBUG("*"); return '*'; }
"/"		{ DEBUG("/"); return '/'; }
"%"		{ DEBUG("%%"); return '%'; }
"&"		{ DEBUG("&"); return '&'; }
"|"		{ DEBUG("|"); return '|'; }
"^"		{ DEBUG("^"); return '^'; }
"@"		{ DEBUG("@"); return '@'; }
"<"		{ DEBUG("<"); return '<'; }
">"		{ DEBUG(">"); return '>'; }
"?"		{ DEBUG("?"); return '?'; }
"("		{ DEBUG("("); return '('; }
")"		{ DEBUG(")"); return ')'; }
"["		{ DEBUG("["); return '['; }
"]"		{ DEBUG("]"); return ']'; }
"{"		{ DEBUG("{"); return '{'; }
"}"		{ DEBUG("}"); return '}'; }
","		{ DEBUG(","); return ','; }
";"		{ DEBUG(";"); return ';'; }
":"		{ DEBUG(":"); return ':'; }
"."		{ DEBUG("."); return '.'; }
"~"		{ DEBUG("~"); return '~'; }

\'(\\.|[^'])\'		{ DEBUG("CHARACTER LITERAL"); return CHAR_LITERAL; }
\"(\\.|[^\\"\n])*\"	{ DEBUG("STRING LITERAL"); return STRING_LITERAL; }

[ \n\t\v\f]		{ DEBUG("WS"); }

.			{ DEBUG("********************* BAD ************************"); /* Discard bad characters */ }

%%

int yywrap(void) {	/* called at end of input */
	return 1;	/* terminate now */
}

void comment(void) {
	int c;
	DEBUG("START COMMENT");
	while ((c = input()) != 0) {
		if (c == '*') {
			while ((c = input()) == '*') {
			}
			if (c == '/') {
				DEBUG("END COMMENT");
				return;
			}
			if (c == 0) {
				break;
			}
		} else if (c == '/') { 		/* check for nested comments */
			if ((c = input()) == '*') {
				DEBUG("NESTED");
				comment(); 	/* nested comments found */
			}
		}
	}
	yyerror("Unterminated comment");
}

