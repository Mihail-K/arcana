
module arcana.grammar.lexer;

import arcana.grammar.rule;
import arcana.grammar.ruleset;
import arcana.grammar.token;

struct Lexer
{
private:
    string _input;
    Token  _token;

    size_t _line;
    size_t _offset;

public:
    this(string input)
    {
        _input = input;
    }

    @property
    bool empty() const
    {
        return !_input || _input.length == 0;
    }

    @property
    Token next()
    {
        if(empty)
        {
            _input = null;
            return token("$", Ruleset.EndOfFile);
        }

        foreach(rule; ruleset)
        {
            if(string match = rule(_input))
            {
                if(rule.discard)
                {
                    advance(match);
                    return next;
                }
                else
                {
                    scope(exit) advance(match);
                    return token(match, rule);
                }
            }
        }

        return token(_input, Ruleset.Error);
    }

private:
    void advance(string text)
    {
        _input = _input[text.length..$];
        
        foreach(ch; text)
        {
            switch(ch)
            {
                case '\t':
                    _offset += 2;
                    break;
                
                case '\n':
                    _offset = 0;
                    _line += 1;
                    break;

                default:
                    _offset += 1;
                    break;
            }
        }
    }

    Token token(string text, Rule rule) const
    {
        return Token(text, rule, _line, _offset);
    }
}

version(unittest)
{
    import std.algorithm;
    import std.array;

    @property
    Token[] tokens(Lexer lexer)
    {
        Token[] array;

        while(!lexer.empty)
        {
            array ~= lexer.next;
        }

        return array;
    }
}

unittest
{
    auto result = Lexer("a + b").tokens;

    with(Ruleset)
    {
        assert(result.map!(t => t.text).array == ["a", "+", "b"]);
        assert(result.map!(t => t.rule).array == cast(Rule[]) [Identifier, Plus, Identifier]);
    }
}

unittest
{
    auto result = Lexer("# This is a comment.\na - b").tokens;

    with(Ruleset)
    {
        assert(result.map!(t => t.text).array == ["a", "-", "b"]);
        assert(result.map!(t => t.rule).array == cast(Rule[]) [Identifier, Minus, Identifier]);
    }
}
