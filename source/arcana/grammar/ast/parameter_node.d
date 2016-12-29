
module arcana.grammar.ast.parameter_node;

import arcana.grammar.token;

import arcana.grammar.ast.expression_node;
import arcana.grammar.ast.node;

import std.string;

class ParameterNode : Node
{
private:
    Token          _name;
    ExpressionNode _type;

public:
    this(Token name, ExpressionNode type = null)
    {
        _name = name;
        _type = type;
    }

    @property
    Token name()
    {
        return _name;
    }

    @property
    ExpressionNode type()
    {
        return _type;
    }

    @property
    override string toString()
    {
        return "%s: %s".format(name, type);
    }
}
