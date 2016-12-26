
module arcana.grammar.ast.relational_node;

import arcana.grammar.token;

import arcana.grammar.ast.binary_node;
import arcana.grammar.ast.expression_node;

class RelationalNode : BinaryNode
{
    this(ExpressionNode left, Token operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
