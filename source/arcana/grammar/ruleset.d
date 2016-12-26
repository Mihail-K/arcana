
module arcana.grammar.ruleset;

import arcana.grammar.matcher;
import arcana.grammar.rule;

import std.ascii;
import std.traits;

enum Ruleset : Rule
{
    Whitespace = Rule(
        "Whitespace",
        repeat!(predicate!(isWhite)),
        Discard.yes
    ),
    
    /+ - Comments - +/

    LineComment = Rule(
        "LineComment",
        allOf!(
            term!("#"),
            option!(
                repeat!(
                    negate!(
                        term!("\n")
                    )
                )
            ),
            term!("\n")
        ),
        Discard.yes
    ),

    /+ - Operators - +/

    Plus = Rule(
        "Plus",
        term!("+")
    ),

    Minus = Rule(
        "Minus",
        term!("-")
    ),

    Times = Rule(
        "Times",
        term!("*")
    ),

    Divide = Rule(
        "Divide",
        term!("/")
    ),

    Modulo = Rule(
        "Modulo",
        term!("%")
    ),

    GreaterOrEqual = Rule(
        "GreaterOrEqual",
        term!(">=")
    ),

    Greater = Rule(
        "Greater",
        term!(">")
    ),

    LessOrEqual = Rule(
        "LessOrEqual",
        term!("<=")
    ),

    Less = Rule(
        "Less",
        term!("<")
    ),

    Equals = Rule(
        "Equals",
        term!("==")
    ),

    Assign = Rule(
        "Assign",
        term!("=")
    ),
    
    NotEquals = Rule(
        "NotEquals",
        term!("!=")
    ),

    Bang = Rule(
        "Bang",
        term!("!")
    ),

    LeftParen = Rule(
        "LeftParen",
        term!("(")
    ),

    RightParen = Rule(
        "RightParen",
        term!(")")
    ),

    /+ - Identifiers - +/

    Identifier = Rule(
        "Identifier",
        allOf!(
            IdentifierFirst,
            option!(
                repeat!(
                    IdentifierMiddle
                )
            ),
            option!(
                IdentifierLast
            )
        )
    ),

    /+ - System - +/

    Error = Rule("Error"),

    EndOfFile = Rule("EndOfFile"),

    Indent = Rule("Indent"),

    Dedent = Rule("Dedent")
}

Rule[] ruleset()
{
    Rule[] ruleset;

    foreach(rule; EnumMembers!(Ruleset))
    {
        static if(!rule.internal)
        {
            ruleset ~= rule;
        }
    }

    return ruleset;
}

unittest
{
    with(Ruleset)
    {
        assert(Identifier("foo") == "foo");
        assert(Identifier("foo-bar") == "foo-bar");
        assert(Identifier("foo - bar") == "foo");
    }
}

private enum IdentifierFirst = oneOf!(
    range!('a', 'z'),
    range!('A', 'Z'),
);

private enum IdentifierMiddle = oneOf!(
    IdentifierLast,
    term!("-")
);

private enum IdentifierLast =  oneOf!(
    IdentifierFirst,
    range!('0', '9')
);
