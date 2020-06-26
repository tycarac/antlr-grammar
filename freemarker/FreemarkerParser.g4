// $antlr-format on
parser grammar FreemarkerParser;
options { tokenVocab=FreemarkerLexer; }   

/*
    https://freemarker.apache.org/docs/dgui_template_exp.html#exp_cheatsheet
    https://freemarker.apache.org/docs/ref_directive_alphaidx.html
*/

root 
    : (tag | interpolation | content)* EOF
    ;

// Tags
tag
    : TAG_START_BEGIN_1 directive_start TAG_END_1
    | TAG_START_BEGIN_2 directive_start TAG_END_2
    | TAG_CLOSE_BEGIN_1 directive_end TAG_END_1
    | TAG_CLOSE_BEGIN_2 directive_end TAG_END_2
    ;

directive_start
    : (DIRECT_IF | DIRECT_ELSEIF) condition
    | DIRECT_ELSE
    | (DIRECT_ASSIGN | DIRECT_SETTING) (assignment)+
    | DIRECT_LIST expression (AS variable (OPER_COMMA variable)*)?
    | DIRECT_INCLUDE expression
    | DIRECT_ESCAPE IDENTIFIER AS expression
    | DIRECT_NOESCAPE
    | DIRECT_MACRO variable+
//    | DIRECT_ITEMS (AS variable)?
//    | DIRECT_SEP
    | DIRECT_FTL
    ;

directive_end
    : DIRECT_IF
    | DIRECT_ASSIGN
    | DIRECT_LIST
    | DIRECT_ESCAPE
    | DIRECT_NOESCAPE
    | DIRECT_MACRO
//    | DIRECT_ITEMS
//    | DIRECT_SEP
    ;

assignment
    : IDENTIFIER OPER_ASSIGN expression
    ;

condition // excludes OPER_GT
    : OPER_L_PAREN condition OPER_R_PAREN
    | OPER_BANG condition 
    | expression OPER_TWO_QUESTION?
    | expression (OPER_QUESTION builtin)+
    | expression (OPER_CMP_EQ | OPER_CMP_NEQ | OPER_CMP_LT | OPER_CMP_LTE | OPER_CMP_GT | OPER_CMP_GTE) expression
    | condition ((OPER_LOGICAL_AND | OPER_LOGICAL_OR) condition)+
    ;

interpolation
    : INTPOL_ENTER expression INTPOL_EXIT
    ;

expression
    // Operator Precedence https://freemarker.apache.org/docs/dgui_template_exp.html#dgui_template_exp_precedence
    : variable | literal
    | variable (OPER_DOT (variable| builtin))+
    | expression (OPER_QUESTION builtin)+
    | expression OPER_BANG (value)?
    | expression (OPER_PLUS | OPER_MODULUS) expression 
    ;

sequence
    : (IDENTIFIER)? SEQ_L_SQ_PAREN SEQ_CONTENT SEQ_R_SQ_PAREN
    ;

builtin
    : IDENTIFIER (OPER_L_PAREN parameterList? OPER_R_PAREN)?
    ;

methodCall
    : IDENTIFIER OPER_L_PAREN parameterList? OPER_R_PAREN
    ;

parameterList
    : expression (OPER_COMMA expression)*
    ;

variable
    : OPER_DOT? IDENTIFIER
    | (IDENTIFIER)? SEQ_L_SQ_PAREN SEQ_CONTENT SEQ_R_SQ_PAREN // sequence
    ;
    
literal
    : STRING | NUMBER | TRUE | FALSE
    ;

value
    : STRING | NUMBER | IDENTIFIER | STRING | NUMBER | TRUE | FALSE
    ;

content
    : CONTENT+
    ;
