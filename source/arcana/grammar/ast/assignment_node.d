
module arcana.grammar.ast.assignment_node;

import arcana.grammar.token;

import arcana.grammar.ast.binary_node;
import arcana.grammar.ast.expression_node;

class AssignmentNode : BinaryNode
{
    this(ExpressionNode left, Token operator, ExpressionNode right)
    {
        super(left, operator, right);
    }
}
