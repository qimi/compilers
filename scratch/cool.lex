/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;
	/* If necessary, add code for other states here, e.g:
	   case COMMENT:
	   ...
	   break;
	*/
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup

%%
/* TODO: Need to revisit the regexes and ordering of the rules */

/* Keywords */
case                            { return new Symbol(TokenConstants.CASE); }
class                           { return new Symbol(TokenConstants.CLASS); }
else                            { return new Symbol(TokenConstants.ELSE); }
esac                            { return new Symbol(TokenConstants.ESAC); }
false                           { return new Symbol(TokenConstants.BOOL_CONST); }
fi                              { return new Symbol(TokenConstants.FI); }
if                              { return new Symbol(TokenConstants.IF); }
in                              { return new Symbol(TokenConstants.IN); }
inherits                        { return new Symbol(TokenConstants.INHERITS); }
isvoid                          { return new Symbol(TokenConstants.ISVOID); }
let                             { return new Symbol(TokenConstants.LET); }
loop                            { return new Symbol(TokenConstants.LOOP); }
new                             { return new Symbol(TokenConstants.NEW); }
not                             { return new Symbol(TokenConstants.NOT); }
of                              { return new Symbol(TokenConstants.OF); }
pool                            { return new Symbol(TokenConstants.POOL); }
then                            { return new Symbol(TokenConstants.THEN); }
true                            { return new Symbol(TokenConstants.BOOL_CONST); }
while                           { return new Symbol(TokenConstants.WHILE); }

/* Operators */
\+                              { return new Symbol(TokenConstants.PLUS); }
\-                              { return new Symbol(TokenConstants.MINUS); }
\*                              { return new Symbol(TokenConstants.MULT); }
/                               { return new Symbol(TokenConstants.DIV); }
<                               { return new Symbol(TokenConstants.LT); }
<=                              { return new Symbol(TokenConstants.LE); }
=                               { return new Symbol(TokenConstants.ASSIGN); }
==                              { return new Symbol(TokenConstants.EQ); }

                                { return new Symbol(TokenConstants.NEG); }

{                               { return new Symbol(TokenConstants.LBRACE); }
}                               { return new Symbol(TokenConstants.RBRACE); }
(                               { return new Symbol(TokenConstants.LPAREN); }
)                               { return new Symbol(TokenConstants.RPAREN); }
:                               { return new Symbol(TokenConstants.COLON); }
;                               { return new Symbol(TokenConstants.SEMI); }
\.                              { return new Symbol(TokenConstants.DOT); }
,                               { return new Symbol(TokenConstants.COMMA); }

/* Constants, identifiers, etc */
[A-Z][A-Za-z0-9_]*              { return new Symbol(TokenConstants.TYPEID); }
[a-z_][A-Za-z0-9_]*             { return new Symbol(TokenConstants.OBJECTID); }
.+                              { return new Symbol(TokenConstants.STR_CONST); }
\-?[0-9]+                       { return new Symbol(TokenConstants.INT_CONST); }

                                { return new Symbol(TokenConstants.EOF); }
				{ return new Symbol(TokenConstants.DARROW); }
                                { return new Symbol(TokenConstants.LET_STMT); }
                                { return new Symbol(TokenConstants.AI); }

                                { return new Symbol(TokenConstants.error); }
                                { return new Symbol(TokenConstants.ERROR); }



<YYINITIAL>"=>"			{ /* Sample lexical rule for "=>" arrow.
                                     Further lexical rules should be defined
                                     here, after the last %% separator */
                                  return new Symbol(TokenConstants.DARROW); }

.                               { /* This rule should be the very last
                                     in your lexical specification and
                                     will match match everything not
                                     matched by other lexical rules. */
                                  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }
