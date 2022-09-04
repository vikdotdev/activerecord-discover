module ActiveRecordDiscover
  class ValidationMatcher < EntityMatcher
    include ASTValidationPatterns

    def match?
      validate? || validates? || validates_each? || validates_with?
    end

    def validate?
      AST.match?(validate_pattern, node)
    end

    def validates?
      AST.match?(validates_pattern, node)
    end

    def validates_each?
      AST.match?(validates_each_pattern, node)
    end

    def validates_with?
      AST.match?(validates_with_pattern, node)
    end
  end
end
