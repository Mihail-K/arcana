
module arcana.grammar.ast.parameter_list_node;

import arcana.grammar.ast.node;
import arcana.grammar.ast.parameter_node;

import std.string;

class ParameterListNode : Node
{
private:
    ParameterNode[] _params;

public:
    this(ParameterNode[] params)
    {
        _params = params;
    }

    @property
    ParameterNode[] params()
    {
        return _params;
    }

    @property
    override string toString()
    {
        return "(%(%s, %))".format(params);
    }
}
