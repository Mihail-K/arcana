
module arcana.grammar.ast.ternary_node;

import arcana.grammar.ast.expression_node;

import std.string;

class TernaryNode : ExpressionNode
{
private:
    ExpressionNode _clause;
    ExpressionNode _left;
    ExpressionNode _right;

public:
    this(ExpressionNode clause, ExpressionNode left, ExpressionNode right)
    {
        _clause = clause;
        _left   = left;
        _right  = right;
    }

    @property
    ExpressionNode clause()
    {
        return _clause;
    }

    @property
    ExpressionNode left()
    {
        return _left;
    }

    @property
    ExpressionNode right()
    {
        return _right;
    }

    @property
    override string toString()
    {
        return "(%s ? %s : %s)".format(clause, left, right);
    }
}
