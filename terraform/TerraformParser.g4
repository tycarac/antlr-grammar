// $antlr-format on
parser grammar TerraformParser;
options { tokenVocab=TerraformLexer; }

root
    : (attribute | block)* EOF 
    ;   

block
    : IDENTIFIER STRING* BRACKET_LCURLY (attribute | block)* BRACKET_RCURLY
    ;

attribute
    : IDENTIFIER OP_ASSIGN (literal | expression | array | dictionary)
    ;

// Expressions
expression
    : expression_term | operation | conditional
    ;

expression_term
    : literal
    | IDENTIFIER (OP_DOT IDENTIFIER)*
    | function
    ;

operation
    : UNARY_OP expression_term
    | expression_term (COMPARE_OP | ARITHMETIC_OP | LOGIC_OP) expression_term
    ;

function
    : IDENTIFIER (OP_DOT IDENTIFIER)* BRACKET_LROUND arguments BRACKET_RROUND
    ;

arguments
    : () 
    | expression (OP_COMMA expression)* (OP_COMMA | OP_ELIPSE)?
    ;

array
    : BRACKET_LSQUARE BRACKET_RSQUARE
    | BRACKET_LSQUARE expression (OP_COMMA expression)* OP_COMMA? BRACKET_RSQUARE
    ;

dictionary
    : BRACKET_LCURLY attribute* BRACKET_RCURLY
    ;

// 
conditional
    : expression_term OP_QUESTION expression OP_COLON expression
    ;


// Primitives
literal
    : STRING | NUMBER | 'true' | 'false' | 'null'
    ;

/*
heredocTemplate
    : (('<<' | '<<-') IDENTIFIER)
    ;
 */