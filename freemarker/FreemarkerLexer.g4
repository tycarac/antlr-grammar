// $antlr-format on
lexer grammar FreemarkerLexer;
tokens{STRING}
/*
 Alternative syntax: https://freemarker.apache.org/docs/dgui_misc_alternativesyntax.html
 Expressions: https://freemarker.apache.org/docs/dgui_template_exp.html

Notes:
1. #{ and }, but that shouldn't be used anymore; https://freemarker.apache.org/docs/ref_depr_numerical_interpolation.html)

*/

// Tags and Interpolations
TAG_START_BEGIN_1           : '<#' -> pushMode(EXPR_MODE); 
TAG_START_BEGIN_2           : '[#' -> pushMode(EXPR_MODE);
TAG_CLOSE_BEGIN_1           : '</#' -> pushMode(EXPR_MODE);
TAG_CLOSE_BEGIN_2           : '[/#' -> pushMode(EXPR_MODE);
INTPOL_ENTER                : '${' -> pushMode(EXPR_MODE);  

// Content
CONTENT                     : ('[' | '<' | '$' | ~[[<$]+)+?;

// Other
WS                          : WHIESPACE -> skip;
COMMENT                     : (FRAG_COMMENT_1 | FRAG_COMMENT_2) -> skip;

// Fragments
fragment WHIESPACE          : [ \t\r\n]+;
fragment SYMBOL             : [a-zA-Z][a-zA-Z0-9_]*;
fragment INTEGER            : [0-9]+;
fragment REAL               : [0-9]+ '.' [0-9]*;
fragment FRAG_COMMENT_1     : '<#--' .*? '-->';
fragment FRAG_COMMENT_2     : '[#--' .*? '--]';


/*
//Experiment
//_____________________________________________________________________________
//CONTENT                     : ('[' | '<' | '$' | ~[[<$]+) -> more;
//CONTENT                     : ('[' | '<' | '$' | ~[[<$]+) -> skip;
//CONTENT                     : ('[' | '<' | '$' | ~[[<$]+)+;
//CONTENT                     : (~[[<$] | (('[' | '<') ~('/' | '#')) | ('$' ~'{'))+;
//CC_CONTENT                  : ~[[<$]+ -> skip;

//_____________________________________________________________________________
mode CONTENT_MODE;

CONTENT_WS                      : WS -> skip;
 */

//_____________________________________________________________________________
mode EXPR_MODE;

TAG_END_1                   : '>' -> popMode;
TAG_END_2                   : ']' -> popMode;
INTPOL_EXIT                 : '}' -> popMode;

// Directives
DIRECT_IF                   : 'if';
DIRECT_ELSE                 : 'else';
DIRECT_ELSEIF               : 'elseif';

DIRECT_ASSIGN               : 'assign';
DIRECT_BREAK                : 'break';
DIRECT_CONTINUE             : 'continue';
DIRECT_FTL                  : 'ftl';
DIRECT_INCLUDE              : 'include';
DIRECT_ESCAPE               : 'escape';
DIRECT_ITEMS                : 'items';
DIRECT_LIST                 : 'list';
DIRECT_MACRO                : 'macro';
DIRECT_NOESCAPE             : 'noescape';
DIRECT_SETTING              : 'setting';
DIRECT_SEP                  : 'sep';

// Keywords
AS                          : 'as';
TRUE                        : 'true';
FALSE                       : 'false';
IN                          : 'in';
USING                       : 'using';

SEQ_L_SQ_PAREN              : '[' -> pushMode(SEQ_MODE);

// Operators
OPER_L_PAREN                : '(';
OPER_R_PAREN                : ')';

OPER_CMP_EQ                 : '==';
OPER_CMP_NEQ                : '!=';

OPER_LOGICAL_AND            : '&&' | '&amp;&amp;';
OPER_LOGICAL_OR             : '||';

OPER_ASSIGN                 : '=';
OPER_AT                     : '@';
OPER_TWO_QUESTION           : '??';
OPER_QUESTION               : '?';
OPER_BANG                   : '!';
OPER_DOT                    : '.';
OPER_COMMA                  : ',';
OPER_COLON                  : ':';
OPER_SEMICOLON              : ';';

OPER_CMP_LT                 : '<' | 'lt';
OPER_CMP_LTE                : '<=' | 'lte';
OPER_CMP_GT                 : 'gt'; 
OPER_CMP_GTE                : '>=' | 'gte';

OPER_PLUS                   : '+';
OPER_MINUS                  : '-';
OPER_MULTIPY                : '*';
OPER_DIVIDE                 : '/';
OPER_MODULUS                : '%';

OPER_LAMBDA                 : '->';

// Literals
SQUOTED_STRING              : '\'' ('\\' . | '\\\'' | ~('\'' | '\\'))* '\'' -> type(STRING);
DQUOTED_STRING              : '"' ('\\' . | '\\"' | ~('"' | '\\'))* '"' -> type(STRING);
NUMBER                      : INTEGER | REAL;

// Variable
IDENTIFIER                  : SYMBOL;

// Skip
EXPR_WS                     : WS -> skip;
EXPR_COMMENT                : (FRAG_COMMENT_1 | FRAG_COMMENT_2) -> skip;

//_____________________________________________________________________________
mode SEQ_MODE;

SEQ_R_SQ_PAREN              : ']' -> popMode;
//SEQ_CONTENT                 : (~[\]])+;
SEQ_CONTENT                 : ('\'' | '"' | ',' | [0-9a-zA-Z])+;
SEQ_WS                      : WS -> skip;