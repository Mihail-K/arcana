
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
        return additive;
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

    TerminalNode terminal()
    {
        if(accept(Ruleset.Identifier))
        {
            return new IdentifierNode(_prev);
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
        enforce(accept(rules));
    }
}

unittest
{
    auto lexer  = Lexer("a + b * c");
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
