
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

    /+ - Literals - +/

    DecimalInt = Rule(
        "DecimalInt",
        allOf!(
            range!('0', '9'),
            option!(
                repeat!(
                    oneOf!(
                        range!('0', '9'),
                        term!("_")
                    )
                )
            )
        )
    ),

    /+ - Keywords - +/

    Fn = Rule(
        "Fn",
        term!("fn")
    ),

    /+ - Operators - +/

    Comma = Rule(
        "Comma",
        term!(",")
    ),

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

    LeftShift = Rule(
        "LeftShift",
        term!("<<")
    ),

    RightShift = Rule(
        "RightShift",
        term!(">>")
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

    Lambda = Rule(
        "Lambda",
        term!("=>")
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

    LogicAnd = Rule(
        "LogicAnd",
        term!("&&")
    ),

    LogicOr = Rule(
        "LogicOr",
        term!("||")
    ),

    Power = Rule(
        "Power",
        term!("^^")
    ),

    BitAnd = Rule(
        "BitAnd",
        term!("&")
    ),

    BitOr = Rule(
        "BitOr",
        term!("|")
    ),

    BitXor = Rule(
        "BitXor",
        term!("^")
    ),

    Query = Rule(
        "Query",
        term!("?")
    ),

    Colon = Rule(
        "Colon",
        term!(":")
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
