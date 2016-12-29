
module arcana.grammar.ast.lambda_node;

import arcana.grammar.ast.expression_node;
import arcana.grammar.ast.parameter_list_node;

import std.string;

class LambdaNode : ExpressionNode
{
private:
    ParameterListNode _params;
    ExpressionNode    _type;
    ExpressionNode    _body;

public:
    this(ParameterListNode params, ExpressionNode type, ExpressionNode body_)
    {
        _params = params;
        _type   = type;
        _body   = body_;
    }
    
    @property
    ParameterListNode params()
    {
        return _params;
    }

    @property
    ExpressionNode type()
    {
        return _type;
    }

    @property
    ExpressionNode body_()
    {
        return _body;
    }

    @property
    override string toString()
    {
        return "fn(%s): %s => %s".format(params, type, body_);
    }
}
