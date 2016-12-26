
module arcana.grammar.parser;

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

    void start()
    {
        expression;
        expect(Ruleset.EndOfFile);
    }

    void expression()
    {
        additive;
    }

    void additive()
    {
        multiplicative;

        while(accept(Ruleset.Plus, Ruleset.Minus))
        {
            multiplicative;
        }
    }

    void multiplicative()
    {
        terminal;

        while(accept(Ruleset.Times, Ruleset.Divide, Ruleset.Modulo))
        {
            terminal;
        }
    }

    void terminal()
    {
        if(accept(Ruleset.Identifier))
        {
            // TODO
        }
        else
        {
            enforce(false);
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
    auto lexer  = Lexer("a + b");
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
