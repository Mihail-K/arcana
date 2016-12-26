
module arcana.grammar.rule;

import arcana.grammar.matcher;

enum Discard : bool
{
    yes = true,
    no  = false
}

struct Rule
{
private:
    string  _name;
    Matcher _matcher;
    Discard _discard;

public:
    this(string name, Matcher matcher = null, Discard discard = Discard.no)
    {
        _name    = name;
        _matcher = matcher;
        _discard = discard;
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

    @property
    Discard discard() const
    {
        return _discard;
    }

    string opCall(string input) const
    {
        return _matcher ? _matcher(input) : null;
    }
}
