module ActiveRecordDiscover
  class EntityMatcher
    include EntityPatterns

    attr_reader :node

    def initialize(node)
      # accepts send type node?
      @node = node
    end

    def send_pattern?
      AST.match?(send_pattern, node)
    end

    def block_pattern?
      AST.match?(block_pattern, node)
    end
  end
end
