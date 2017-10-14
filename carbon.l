BINARY		[0-1]
OCTAL		[0-7]
DECIMAL		[0-9]
HEX		[a-fA-F0-9]
BINARY_PREFIX	"2x"
OCTAL_PREFIX	"8x"
DECIMAL_PREFIX	"10x"
HEX_PREFIX	"16x"

E_EXP		([Ee][+-]?{DECIMAL}+)
P_EXP		([Pp][+-]?{DECIMAL}+)

%{

#include "carbon.tab.h"
extern FILE *yyin;
void comment(void);
#define D(s) printf("LEXER: " s "\n");

%}

%%

"/*"		{ comment(); }
"//".*		{ /* consume single line comment */ }

alloc		{ D("ALLOC"); return ALLOC; }
asm		{ D("ASM"); return ASM; }
atomic		{ D("ATOMIC"); return ATOMIC; }
auto		{ D("AUTO"); return AUTO; }
bool		{ D("BOOL"); return BOOL; }
break		{ D("BREAK"); return BREAK; }
calloc		{ D("CALLOC"); return CALLOC; }
case		{ D("CASE"); return CASE; }
char		{ D("CHAR"); return CHAR; }
const		{ D("CONST"); return CONST; }
continue	{ D("CONTINUE"); return CONTINUE; }
def		{ D("DEF"); return DEF; }
default		{ D("DEFAULT"); return DEFAULT; }
defer		{ D("DEFER"); return DEFER; }
do		{ D("DO"); return DO; }
else		{ D("ELSE"); return ELSE; }
enum		{ D("ENUM"); return ENUM; }
extern		{ D("EXTERN"); return EXTERN; }
false		{ D("FALSE"); return FALSE; }
float32		{ D("FLOAT32"); return FLOAT32; }
float64		{ D("FLOAT64"); return FLOAT64; }
float128	{ D("FLOAT128"); return FLOAT128; }
for		{ D("FOR"); return FOR; }
foreach		{ D("FOREACH"); return FOREACH; }
free		{ D("FREE"); return FREE; }
generic		{ D("GENERIC"); return GENERIC; }
goto		{ D("GOTO"); return GOTO; }
if		{ D("IF"); return IF; }
in		{ D("IN"); return IN; }
int		{ D("INT"); return INT; }
int8		{ D("INT8"); return INT8; }
int16		{ D("INT16"); return INT16; }
int32		{ D("INT32"); return INT32; }
int64		{ D("INT64"); return INT64; }
module		{ D("MODULE"); return MODULE; }
new		{ D("NEW"); return NEW; }
nil		{ D("NIL"); return NIL; }
private		{ D("PRIVATE"); return PRIVATE; }
protect		{ D("PROTECT"); return PROTECT; }
ptr		{ D("PTR"); return PTR; }
public		{ D("PUBLIC"); return PUBLIC; }
register	{ D("REGISTER"); return REGISTER; }
require		{ D("REQUIRE"); return REQUIRE; }
restrict	{ D("RESTRICT"); return RESTRICT; }
return		{ D("RETURN"); return RETURN; }
static		{ D("STATIC"); return STATIC; }
string		{ D("STRING"); return STRING; }
struct		{ D("STRUCT"); return STRUCT; }
switch		{ D("SWITCH"); return SWITCH; }
true		{ D("TRUE"); return TRUE; }
type		{ D("TYPE"); return TYPE; }
uint		{ D("UINT"); return UINT; }
uint8		{ D("UINT8"); return UINT8; }
uint16		{ D("UINT16"); return UINT16; }
uint32		{ D("UINT32"); return UINT32; }
uint64		{ D("UINT64"); return UINT64; }
union		{ D("UNION"); return UNION; }
volatile	{ D("VOLATILE"); return VOLATILE; }
while		{ D("WHILE"); return WHILE; }

"_"		{ D("_"); return '_'; }

[a-zA-Z_][a-zA-Z_0-9]*		{ D("IDENTIFIER"); return IDENTIFIER; }

{BINARY_PREFIX}{BINARY}+	{ D("BINARY CONSTANT"); return BINARY_CONST; }
{OCTAL_PREFIX}{OCTAL}+		{ D("OCTAL CONSTANT"); return OCTAL_CONST; }
{DECIMAL_PREFIX}{DECIMAL}+	{ D("DECIMAL CONSTANT"); return DECIMAL_CONST; }
{HEX_PREFIX}{HEX}+		{ D("HEX CONSTANT"); return HEX_CONST; }
{DECIMAL}+			{ D("DECIMAL CONSTANT WITHOUT PREFIX"); return DECIMAL_CONST; }

{DECIMAL}+{E_EXP}			{ D("CLASS A FLOAT CONSTANT"); return FLOAT_CONST; }
{DECIMAL}*"."{DECIMAL}+{E_EXP}?		{ D("CLASS B FLOAT CONSTANT"); return FLOAT_CONST; }
{DECIMAL}+"."{E_EXP}?			{ D("CLASS C FLOAT CONSTANT"); return FLOAT_CONST; }
{HEX_PREFIX}{HEX}+{P_EXP}		{ D("CLASS D FLOAT CONSTANT"); return FLOAT_CONST; }
{HEX_PREFIX}{HEX}*"."{HEX}+{P_EXP}	{ D("CLASS E FLOAT CONSTANT"); return FLOAT_CONST; }
{HEX_PREFIX}{HEX}+"."{P_EXP}		{ D("CLASS F FLOAT CONSTANT"); return FLOAT_CONST; }

">>="		{ D("LS_ASSIGN_OP"); return LS_ASSIGN_OP; }
"<<="		{ D("RS_ASSIGN_OP"); return RS_ASSIGN_OP; }
">>"		{ D("LS_OP"); return LS_OP; }
"<<"		{ D("RS_OP"); return RS_OP; }
"=="		{ D("EQ_OP"); return EQ_OP; }
"!="		{ D("NE_OP"); return NE_OP; }
">="		{ D("GE_OP"); return GE_OP; }
"<="		{ D("LE_OP"); return LE_OP; }
"&&"		{ D("AND_OP"); return AND_OP; }
"||"		{ D("OR_OP"); return OR_OP; }
"++"		{ D("INC_OP"); return INC_OP; }
"--"		{ D("DEC_OP"); return DEC_OP; }
"+="		{ D("ADD_ASSIGN_OP"); return ADD_ASSIGN_OP; }
"-="		{ D("SUB_ASSIGN_OP"); return SUB_ASSIGN_OP; }
"*="		{ D("MUL_ASSIGN_OP"); return MUL_ASSIGN_OP; }
"/="		{ D("DIV_ASSIGN_OP"); return DIV_ASSIGN_OP; }
"%="		{ D("MOD_ASSIGN_OP"); return MOD_ASSIGN_OP; }
"&="		{ D("AND_ASSIGN_OP"); return AND_ASSIGN_OP; }
"|="		{ D("OR_ASSIGN_OP"); return OR_ASSIGN_OP; }
"^="		{ D("XOR_ASSIGN_OP"); return XOR_ASSIGN_OP; }
"->"		{ D("MINUS_GR_OP"); return MINUS_GR_OP; }

"="		{ D("="); return '='; }
"+"		{ D("+"); return '+'; }
"-"		{ D("-"); return '-'; }
"*"		{ D("*"); return '*'; }
"/"		{ D("/"); return '/'; }
"%"		{ D("%%"); return '%'; }
"&"		{ D("&"); return '&'; }
"|"		{ D("|"); return '|'; }
"^"		{ D("^"); return '^'; }
"@"		{ D("@"); return '@'; }
"<"		{ D("<"); return '<'; }
">"		{ D(">"); return '>'; }
"("		{ D("("); return '('; }
")"		{ D(")"); return ')'; }
"["		{ D("["); return '['; }
"]"		{ D("]"); return ']'; }
","		{ D(","); return ','; }
";"		{ D(";"); return ';'; }
":"		{ D(":"); return ':'; }
"."		{ D("."); return '.'; }
"~"		{ D("~"); return '~'; }

"%q{"(\\.|[^\}])*"}"	{ D("RAW_STRING LITERAL"); return RAW_STRING_LITERAL; }
"%Q{"(\\.|[^\}])*"}"	{ D("STRING LITERAL"); return STRING_LITERAL; }
\'(\\.|[^\\'])*\'	{ D("RAW_STRING LITERAL"); return RAW_STRING_LITERAL; }
\"(\\.|[^\\"])*\"	{ D("STRING LITERAL"); return STRING_LITERAL; }

[ \n\t\v\f]		{ D("WS"); }

.			{ D("********************* BAD ************************"); /* Discard bad characters */ }

%%

int yywrap(void) {	/* called at end of input */
	return 1;	/* terminate now */
}

void comment(void) {
	int c;
	while ((c = input()) != 0) {
		if (c == '*') {
			while ((c = input()) == '*') {
			}
			if (c == '/') {
				return;
			}
			if (c == 0) {
				break;
			}
		} else if (c == '/') { 		/* check for nested comments */
			if ((c = input()) == '*') {
				comment(); 	/* nested comments found */
			}
		}
	}
	yyerror("Unterminated comment");
}

