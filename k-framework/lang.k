module LANG-SYNTAX
    imports DOMAINS-SYNTAX

    syntax Exp ::= Int | Bool | Id
                 | "(" Exp ")" [bracket]
                 | "++" Exp
                 | "--" Exp
                 > left: 
                   "!" Exp [strict]
                 > left: 
                   Exp "**" Exp [strict]
                 > left: 
                   Exp "*" Exp [strict]
                 | Exp "/" Exp [strict]
                 | Exp "%" Exp [strict]
                 > left: 
                   Exp "+" Exp [strict]
                 | Exp "-" Exp [strict]
                 > non-assoc:
                   Exp "==" Exp [strict]
                 | Exp "!=" Exp [strict]
                 | Exp "<" Exp [strict]
                 | Exp "<=" Exp [strict]
                 | Exp ">" Exp [strict]
                 | Exp ">=" Exp [strict]
                 > left: 
                   Exp "^" Exp [strict]
                 > left: 
                   Exp "&&" Exp [strict]
                 > left: 
                   Exp "||" Exp [strict]
                 > right:
                   "int" Id "=" Exp [strict(2)]
                 | "bool" Id "=" Exp [strict(2)]
                 |  Id "=" Exp [strict(2)]

    syntax Block ::= "{" Stmt "}" | "{" "}"

    syntax Stmt ::= Stmt Stmt [left]
                | Exp ";" [strict]
                | Block
                | "if" "(" Exp ")" Block "else" Block  [strict(1)]
                | "if" "(" Exp ")" Block  [strict(1)]
                | "while" "(" Exp ")" Block  [strict(1)]
                | "for" "(" Exp ";" Exp ";" Exp ")" Block
endmodule

module LANG
    imports LANG-SYNTAX
    imports DOMAINS

    configuration
    <T>
        <k> $PGM:Stmt </k>
        <state> .Map </state>
    </T>

    rule <k> ! B:Bool => notBool B ...</k>
    rule <k> A:Bool && B:Bool => A andBool B ...</k>
    rule <k> A:Bool ^ B:Bool => A xorBool B ...</k>
    rule <k> A:Bool || B:Bool => A orBool B ...</k>
    
    rule <k> A:Int < B:Int => A <Int B ...</k>
    rule <k> A:Int > B:Int => A >Int B ...</k>
    rule <k> A:Int <= B:Int => A <=Int B ...</k>
    rule <k> A:Int >= B:Int => A >=Int B ...</k>
    rule <k> A:Int == B:Int => A ==Int B ...</k>
    rule <k> A:Int != B:Int => A =/=Int B ...</k>

    rule <k> A:Int + B:Int => A +Int B ...</k>
    rule <k> A:Int - B:Int  => A -Int B ...</k>
    rule <k> A:Int * B:Int => A *Int B ...</k>
    rule <k> A:Int / B:Int => A /Int B ...</k>
    rule <k> A:Int ** B:Int => A ^Int B ...</k>
    rule <k> A:Int % B:Int => A %Int B ...</k>

    rule <k> ++ X:Id => I + 1 ...</k>
       <state>... X |-> (I => I +Int 1) ...</state>
    rule <k> -- X:Id => I - 1 ...</k>
       <state>... X |-> (I => I -Int 1) ...</state>

    rule <k> { S:Stmt } => S:Stmt ... </k>
    rule <k> {   } => . ... </k>

    rule <k> S1:Stmt S2:Stmt => S1 ~> S2 ... </k> [structural]
    rule _:Int ; => .
    rule _:Bool ; => .

    // get int variable
    rule <k> X:Id => I:Int ...</k>
        <state>... X |-> I ...</state>

    // set int variable
    rule <k> int X:Id = I:Int => I ...</k>
        <state> STATE => STATE [ X <- I ] </state>
    
    // set existed Int variable
    rule <k> X:Id = B:Int => B ...</k>
        <state> STATE => STATE [ X <- B ] </state>

    // get bool variable
    rule <k> X:Id => B:Bool ...</k>
        <state>... X |-> B ...</state>

    // set bool variable
    rule <k> bool X:Id = B:Bool => B ...</k>
        <state> STATE => STATE [ X <- B ] </state>

    // set existed Bool variable
    rule <k> X:Id = B:Bool => B ...</k>
        <state> STATE => STATE [ X <- B ] </state>
    
    rule <k> if (true:Bool) S else _ => S ... </k>
    rule <k> if (false:Bool) _ else S => S ... </k>
    rule <k> if (CONDITION:Bool) THEN:Block else ELSE:Block => if (CONDITION:Bool) THEN else ELSE ... </k> [owise]

    rule <k> if (true:Bool) S  => S ... </k>
    rule <k> if (false:Bool) _ => . ... </k>
    rule <k> if (CONDITION:Bool) THEN:Block => if (CONDITION:Bool) THEN ... </k> [owise]

    rule <k> while ( CONDITION ) BODY => if ( CONDITION ) { BODY while ( CONDITION ) BODY } ... </k>

    rule <k> for ( INIT ; STOP ; STEP ) BODY => {INIT ; while ( STOP ) { BODY STEP; }} ... </k>

    syntax KResult ::= Int | Bool

endmodule
