
module arcana.lexer.rule;

import arcana.lexer.matcher;

struct Rule
{
private:
    string  _name;
    Matcher _matcher;

public:
    this(string name, Matcher matcher)
    {
        _name    = name;
        _matcher = matcher;
    }

    @property
    string name() const
    {
        return _name;
    }

    @property
    Matcher matcher() const
    {
        return _matcher;
    }
}
