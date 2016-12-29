
module arcana.grammar.parser;

import arcana.grammar.ast;
import arcana.grammar.lexer;
import arcana.grammar.rule;
import arcana.grammar.ruleset;
import arcana.grammar.token;

import std.algorithm;
import std.exception;

struct Parser
{
private:
    Lexer _lexer;

    Token _curr;
    Token _prev;

public:
    this(Lexer lexer)
    {
        _lexer = lexer;
        advance;
    }

    ExpressionNode start()
    {
        auto node = expression;
        expect(Ruleset.EndOfFile);
        return node;
    }

    ExpressionNode expression()
    {
        return assignment;
    }

    ExpressionNode assignment()
    {
        auto left = logical;

        if(accept(Ruleset.Assign))
        {
            return new AssignmentNode(left, _prev, assignment);
        }

        return left;
    }

    ExpressionNode ternary()
    {
        auto left = logical;

        if(accept(Ruleset.TernaryThen))
        {
            auto node = expression;
            expect(Ruleset.TernaryElse);

            return new TernaryNode(left, node, expression);
        }

        return left;
    }

    ExpressionNode logical()
    {
        auto left = equality;

        if(accept(Ruleset.LogicAnd, Ruleset.LogicOr))
        {
            return new LogicalNode(left, _prev, logical);
        }

        return left;
    }

    ExpressionNode equality()
    {
        auto left = relational;

        if(accept(Ruleset.Equals, Ruleset.NotEquals))
        {
            return new EqualityNode(left, _prev, equality);
        }

        return left;
    }

    ExpressionNode relational()
    {
        auto left = bitwise;

        with(Ruleset)
        {
            if(accept(Greater, GreaterOrEqual, Less, LessOrEqual))
            {
                return new RelationalNode(left, _prev, relational);
            }
        }

        return left;
    }

    ExpressionNode bitwise()
    {
        auto left = additive;

        with(Ruleset)
        {
            if(accept(LeftShift, RightShift, BitAnd, BitOr, BitXor))
            {
                return new BitwiseNode(left, _prev, bitwite);
            }
        }

        return left;
    }

    ExpressionNode additive()
    {
        auto left = multiplicative;

        if(accept(Ruleset.Plus, Ruleset.Minus))
        {
            return new AdditiveNode(left, _prev, additive);
        }

        return left;
    }

    ExpressionNode multiplicative()
    {
        auto left = terminal;

        if(accept(Ruleset.Times, Ruleset.Divide, Ruleset.Modulo))
        {
            return new MultiplicativeNode(left, _prev, multiplicative);
        }

        return left;
    }

    ExpressionNode terminal()
    {
        if(accept(Ruleset.Identifier))
        {
            return new IdentifierNode(_prev);
        }
        else if(accept(Ruleset.LeftParen))
        {
            auto node = expression;
            expect(Ruleset.RightParen);
            return node;
        }
        else
        {
            enforce(false);
            assert(false);
        }
    }

private:
    void advance()
    {
        _prev = _curr;
        _curr = _lexer.next;
    }

    bool accept(Rule[] rules...)
    {
        if(rules.countUntil(_curr.rule) != -1)
        {
            advance;
            return true;
        }

        return false;
    }

    void expect(Rule[] rules...)
    {
        enforce(accept(rules), "Got: " ~ _curr.text);
    }
}

unittest
{
    auto lexer  = Lexer("(a + b) * c > d == e <= f");
    auto parser = Parser(lexer);

    try
    {
        parser.start;
    }
    catch(Exception e)
    {
        assert(false);
    }
}
