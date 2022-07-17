class Hash
  def inspect_no_parenthesis
    inspect.chop.reverse.chop.reverse
  end
end

class String
  def to_ast
    ActiveRecordDiscover::AST.from(self)
  end
end
