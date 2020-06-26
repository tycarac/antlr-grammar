// $antlr-format on
lexer grammar TerraformLexer;
tokens{STRING, BOOL}
/* Syntax HCL - https://github.com/hashicorp/hcl/blob/hcl2/hclsyntax/spec.md
*/

// Other
WS                          : [ \t\r\n]+ -> skip;
COMMENT                     : (INLINE_COMMENT | LINE_COMMENT) -> skip;

// Fragments
fragment SYMBOL             : [a-zA-Z][a-zA-Z0-9_-]*;
fragment EXPONENT_MARKER    : ('e' | 'E') ('+' | '-')?;
fragment INLINE_COMMENT     : '/*' .*? '*/';
fragment LINE_COMMENT       : ('//' | '#') ~ [\r\n]*;

// Operators
BRACKET_LROUND              : '(';
BRACKET_RROUND              : ')';
BRACKET_LSQUARE             : '[';
BRACKET_RSQUARE             : ']';
BRACKET_LCURLY              : '{';
BRACKET_RCURLY              : '}';

OP_ASSIGN                   : '=';
OP_DOT                      : '.';
OP_ELIPSE                   : '...';
OP_COMMA                    : ',';
OP_COLON                    : ':';
OP_QUESTION                 : '?';
OP_BAR                      : '|';

OP_MULTILINE                : '<<';

UNARY_OP                    : '-' | '!';
COMPARE_OP                  : '==' | '!=' | '<' | '>' | '<=' | '>=';
ARITHMETIC_OP               : '+' | '-' | '*' | '/' | '%';
LOGIC_OP                    : '&&' | '||';


// Base prefix
HEX                         : '0x' ([0-9] | [A-F])+;
OCTAL                       : '0' [0-7]+;


// Literals
STRING_DQUOTED              : '"' ('\\' . | '\\"' | ~('"' | '\\'))* '"' -> type(STRING);
NUMBER                      : [0-9]+ ('.' [0-9]+)? (EXPONENT_MARKER [0-9]+)?;
TRUE                        : 'true';
FALSE                       : 'false';
NULL                        : 'null';


// Variable
IDENTIFIER                  : SYMBOL;
