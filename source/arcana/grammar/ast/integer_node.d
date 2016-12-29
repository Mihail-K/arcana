
module arcana.grammar.ast.integer_node;

import arcana.grammar.token;

import arcana.grammar.ast.literal_node;

class IntegerNode : LiteralNode
{
    this(Token token)
    {
        super(token);
    }
}
