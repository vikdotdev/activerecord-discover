module ActiveRecordDiscover
  class ASTEntity
    attr_reader :ast, :model

    def initialize(ast, model)
      @ast = ast
      @model = model
    end

    def methods
      []
    end

    def condition_methods
      []
    end

    def as_printable
      @as_printable ||= [self, methods, condition_methods].flatten
    end

    def <=>(other)
      ast.loc.first_line <=> other.ast.loc.first_line
    end
  end
end
