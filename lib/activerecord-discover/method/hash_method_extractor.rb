module ActiveRecordDiscover
  class HashMethodExtractor
    attr_reader :node

    def initialize(node)
      @node = node
    end

    def call
      node.each_child_node.map do |child|
        case child
        in :hash, *pair_nodes
          pair_nodes.map do |pair_node|
            case pair_node
            in [:pair, [:sym, :if | :unless], [:sym, method_name]]
              method_name
            in [:pair, [:sym, :if | :unless], [:array, *array_nodes]]
              array_nodes.select(&:sym_type?).map do |sym_node|
                sym_node in [:sym, method_name]

                method_name
              end
            else
              next
            end
          end
        else
          next
        end
      end.flatten.compact.uniq
    end
  end
end
