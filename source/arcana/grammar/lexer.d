
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
    Token[] array()
    {
        Token[] array;

        while(!empty)
        {
            array ~= next;
        }

        return array;
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

unittest
{
    import std.algorithm;
    import std.array;

    auto lexer = Lexer("a + b");
    import std.stdio;
    writefln("%(%s,\n%)", lexer.array);
}
