
module arcana.grammar.matcher;

import std.array;
import std.string;

alias Matcher = string function(string);

template predicate(alias pred)
{
    enum predicate = function string(string input)
    {
        if(input.length && pred(input[0]))
        {
            return [input[0]];
        }
        else
        {
            return null;
        }
    };
}

template term(literals...) if(literals.length > 0)
{
    enum term = function string(string input)
    {
        foreach(literal; literals)
        {
            if(input.startsWith(literal))
            {
                return literal;
            }
        }

        return null;
    };
}

unittest
{
    Matcher matcher = term!("a", "b");

    assert(matcher("a") == "a");
    assert(matcher("b") == "b");
    assert(matcher("c") == null);
}

unittest
{
    Matcher matcher = term!("a");

    assert(matcher("aba") == "a");
    assert(matcher("bab") == null);
    assert(matcher("aaa") == "a");
}

template range(dchar min, dchar max) if(min < max)
{
    enum range = function string(string input)
    {
        if(input.length && input[0] >= min && input[0] <= max)
        {
            return [input[0]];
        }
        else
        {
            return null;
        }
    };
}

unittest
{
    Matcher matcher = range!('a', 'f');

    assert(matcher("a") == "a");
    assert(matcher("f") == "f");
    assert(matcher("g") == null);
}

template negate(alias matcher)
{
    enum negate = function string(string input)
    {
        string match = matcher(input);
        return match ? null : [input[0]];
    };
}

unittest
{
    Matcher matcher = negate!(term!("a", "b"));

    assert(matcher("a") == null);
    assert(matcher("b") == null);
    assert(matcher("c") == "c");
}

template option(alias matcher)
{
    enum option = function string(string input)
    {
        string match = matcher(input);
        return match ? match : "";
    };
}

unittest
{
    Matcher matcher = option!(term!("a", "b"));

    assert(matcher("a") == "a");
    assert(matcher("b") == "b");
    assert(matcher("c") == "");
}

template repeat(alias matcher)
{
    enum repeat = function string(string input)
    {
        auto buffer = appender!string;

        while(true)
        {
            string match = matcher(input);
            if(match is null) break;

            input = input[match.length..$];
            buffer ~= match;
        }

        return buffer.data;
    };
}

unittest
{
    Matcher matcher = repeat!(term!("a", "b"));

    assert(matcher("a") == "a");
    assert(matcher("b") == "b");
    assert(matcher("c") == null);
}

unittest
{
    Matcher matcher = repeat!(term!("a", "b"));

    assert(matcher("aba") == "aba");
    assert(matcher("baz") == "ba");
    assert(matcher("cab") == null);
}

template allOf(matchers...) if(matchers.length > 0)
{
    enum allOf = function string(string input)
    {
        auto buffer = appender!string;

        foreach(matcher; matchers)
        {
            if(string match = matcher(input))
            {
                input = input[match.length..$];
                buffer ~= match;
            }
            else
            {
                return null;
            }
        }

        return buffer.data;
    };
}

unittest
{
    Matcher matcher = allOf!(
        term!("a", "b"),
        term!("c", "d")
    );

    assert(matcher("ad") == "ad");
    assert(matcher("bc") == "bc");
    assert(matcher("ab") == null);
}

template oneOf(matchers...) if(matchers.length > 0)
{
    enum oneOf = function string(string input)
    {
        foreach(matcher; matchers)
        {
            if(string match = matcher(input))
            {
                return match;
            }
        }

        return null;
    };
}

unittest
{
    Matcher matcher = oneOf!(
        term!("a", "b"),
        term!("c", "d")
    );

    assert(matcher("a") == "a");
    assert(matcher("c") == "c");
    assert(matcher("f") == null);
}
