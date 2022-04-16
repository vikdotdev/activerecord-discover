class Hash
  def inspect_no_parenthesis
    inspect.chop.reverse.chop.reverse
  end
end

class String
  def to_ast
    Fast.ast(self)
  end
end
