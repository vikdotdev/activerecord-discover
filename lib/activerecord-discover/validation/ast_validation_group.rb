module ActiveRecordDiscover
  # TODO remove this dummy class once callback interface changes to
  # fetch printable targets straight from the AST entity
  class ASTValidationGroup
    attr_reader :validation

    def initialize(ast_validation)
      @validation = ast_validation
    end

    def printable_targets
      @validation.as_printable
    end
  end
end
