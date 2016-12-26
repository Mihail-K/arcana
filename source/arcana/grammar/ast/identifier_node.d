
module arcana.grammar.ast.identifier_node;

import arcana.grammar.token;

import arcana.grammar.ast.terminal_node;

class IdentifierNode : TerminalNode
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
        return _token.text;
    }
}
