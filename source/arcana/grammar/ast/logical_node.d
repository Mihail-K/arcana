
module arcana.grammar.ast.logical_node;

import arcana.grammar.token;

import arcana.grammar.ast.binary_node;
import arcana.grammar.ast.expression_node;

class LogicalNode : BinaryNode
{
    this(ExpressionNode left, Token operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
