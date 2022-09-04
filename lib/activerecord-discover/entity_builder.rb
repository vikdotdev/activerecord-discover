module ActiveRecordDiscover
  class EntityBuilder
    attr_reader :node, :matcher

    def initialize(node, matcher)
      @node = node
      @matcher = matcher
      @send_type_nodes = []
      @block_type_nodes = []
    end

    def call
      extract_send_type_nodes!
      extract_block_type_nodes!

      @send_type_nodes + @block_type_nodes
    end

    def extract_send_type_nodes!
      @send_type_nodes = node.descendants.select do |node|
        node.send_type? && matcher.new(node).match?
      end
    end

    def extract_block_type_nodes!
      # TODO improve this deleting bit
      to_delete = []
      @block_type_nodes = @send_type_nodes.map do |send_type_node|
        next unless send_type_node.parent.block_type? &&
                    matcher.new(send_type_node).match? &&
                    matcher.new(send_type_node.parent).block_pattern?

        to_delete << send_type_node
        send_type_node.parent
      end.compact

      @send_type_nodes = @send_type_nodes - to_delete
    end
  end
end
