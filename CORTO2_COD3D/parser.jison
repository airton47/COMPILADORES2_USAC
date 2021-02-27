/* description: Parses end executes mathematical expressions. */

%{
    var cont = 0;
    console.log("Se inicia el analisis");
    var new_temp = () => {
        cont ++;
        return 'var'+cont;
    }
%}

/* lexical grammar */
%lex
%%

\s+                   /* skip whitespace */
[0-9]+("."[0-9]+)?\b  return 'NUMBER'
[a-zA-Z"_"]+[a-zA-Z0-9"_"]* %{  return 'ID'; %}
"*"                   return '*'
"/"                   return '/'
"-"                   return '-'
"+"                   return '+'
"^"                   return '^'
"("                   return '('
")"                   return ')'

<<EOF>>               return 'EOF'
.                     return 'INVALID'

/lex

/* operator associations and precedence */

%left '+' '-'
%left '*' '/'
%left '^'
%left UMINUS

%start expressions

%% /* language grammar */

expressions
    : E EOF
        { $$ = $1; }
    ;

E
    : E '+' T {
        $$.TMP = new_temp();
        $$.C3D = $1.C3D + $2.C3D + $$.TMP + "=" + $1.TMP + "+" +$2.TMP;
        }
    | E '-' T {
        $$.TMP = new_temp();
        $$.C3D = $1.C3D + $2.C3D + $$.TMP + "=" + $1.TMP + "-" +$2.TMP;
        }
    | T {
        $$.C3D = $1.C3D;
        $$.TMP = $1.TMP;
        }
;

T
    : T '*' F {
        $$.TMP = new_temp();
        $$.C3D = $1.C3D + $2.C3D + $$.TMP + "=" + $1.TMP + "*" +$2.TMP;
        }
    | T '/' F {
        $$.TMP = new_temp();
        $$.C3D = $1.C3D + $2.C3D + $$.TMP + "=" + $1.TMP + "/" +$2.TMP;
        }
    | F {
        
        $$.TMP = $1.TMP;
        $$.C3D = $1.C3D;
        }
;

F
    : '(' F ')' { 
        $$.TMP = $2.TMP;
        $$.C3D = $2.C3D;
        }
    | NUMBER {
        $$.TMP = $1;        
        $$.C3D = "";  
        }
    | ID {
        $$.TMP = $1;
        $$.C3D = ""; 
        }
;

%%
