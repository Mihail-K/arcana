
module arcana.grammar.token;

import arcana.grammar.rule;

struct Token
{
private:
    string _text;
    Rule   _rule;
    size_t _line;
    size_t _offset;

public:
    this(string text, Rule rule, size_t line, size_t offset)
    {
        _text   = text;
        _rule   = rule;
        _line   = line;
        _offset = offset;
    }

    @property
    string text() const
    {
        return _text;
    }

    @property
    Rule rule() const
    {
        return _rule;
    }

    @property
    size_t line() const
    {
        return _line;
    }

    @property
    size_t offset() const
    {
        return _offset;
    }
}
