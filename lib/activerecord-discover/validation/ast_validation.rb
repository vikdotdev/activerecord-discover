module ActiveRecordDiscover
  class ASTValidation < ASTEntity
    include ASTValidationPatterns

    def self.from_path(path, model)
      EntityBuilder.new(AST.from_path(path), ValidationMatcher).call.map do |node|
        new(node, model)
      end.compact.uniq.sort
    end

    # TODO rename argument_methods
    def argument_methods
      return [] unless ValidationMatcher.new(send_node).validate?

      ArgumentMethodExtractor.new(send_node).call.map do |name|
        ASTMethod.from(model, by_name: name)
      end
    end

    # TODO rename hash_methods
    def hash_methods
      HashMethodExtractor.new(send_node).call.map do |name|
        ASTMethod.from(model, by_name: name)
      end.uniq(&:ast)
    end
  end
end
