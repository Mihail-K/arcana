
module arcana.grammar.ast.equality_node;

import arcana.grammar.token;

import arcana.grammar.ast.binary_node;
import arcana.grammar.ast.expression_node;

class EqualityNode : BinaryNode
{
    this(ExpressionNode left, Token operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
