
module arcana.grammar.rule;

import arcana.grammar.matcher;

struct Rule
{
private:
    string  _name;
    Matcher _matcher;

public:
    this(string name, Matcher matcher = null)
    {
        _name    = name;
        _matcher = matcher;
    }

    @property
    bool internal() const
    {
        return _matcher is null;
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

    string opCall(string input) const
    {
        return _matcher ? _matcher(input) : null;
    }
}
