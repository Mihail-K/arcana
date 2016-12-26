
module arcana.grammar.ast.binary_node;

import arcana.grammar.token;

import arcana.grammar.ast.expression_node;

import std.string;

abstract class BinaryNode : ExpressionNode
{
private:
    ExpressionNode _left;
    Token          _operator;
    ExpressionNode _right;

public:
    this(ExpressionNode left, Token operator, ExpressionNode right)
    {
        _left     = left;
        _operator = operator;
        _right    = right;
    }

    @property
    ExpressionNode left()
    {
        return _left;
    }

    @property
    Token operator()
    {
        return _operator;
    }

    @property
    ExpressionNode right()
    {
        return _right;
    }

    @property
    override string toString()
    {
        return format("(%s %s %s)", left, operator.text, right);
    }
}
