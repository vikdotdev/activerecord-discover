module ActiveRecordDiscover
  class ArgumentMethodExtractor
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def call
      node.each_child_node.map do |child|
        case child
        in :sym, method_name then method_name
        else nil
        end
      end.compact.flatten.uniq
    end
  end
end
