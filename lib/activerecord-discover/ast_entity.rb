module ActiveRecordDiscover
  class ASTEntity
    attr_reader :ast, :send_node, :model

    def initialize(ast, model)
      # TODO rename this to original_node ??
      @ast = ast
      @send_node = extract_send_type_node_from(ast)
      @model = model
    end

    def argument_methods
      []
    end

    def hash_methods
      []
    end

    def printables
      @printables ||= [self, methods, condition_methods].flatten
    end

    def <=>(other)
      ast.loc.first_line <=> other.ast.loc.first_line
    end

    # TODO not used yet, remove if not needed
    def include?(other)
      ast.descendants.any? { |descendant| descendant == other }
    end

    private

    def extract_send_type_node_from(node)
      return node if node.send_type?

      node.descendants.select(&:send_type?).flatten.first
    end
  end
end
