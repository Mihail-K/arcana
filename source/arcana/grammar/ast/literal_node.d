
module arcana.grammar.ast.literal_node;

import arcana.grammar.token;

import arcana.grammar.ast.terminal_node;

abstract class LiteralNode : TerminalNode
{
private:
    Token _token;

public:
    this(Token token)
    {
        _token = token;
    }

    @property
    Token token()
    {
        return _token;
    }

    @property
    override string toString()
    {
        return token.text;
    }
}
