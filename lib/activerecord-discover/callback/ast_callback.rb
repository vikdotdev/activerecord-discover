# -*- experimental-syntax: true -*-
# Warning[:experimental] = false
module ActiveRecordDiscover

  # TODO rename all these ? to exclude AST
  class ASTCallback < ASTEntity
    def self.from_path(path, model)
      AST.from_path(path).descendants
      .select { |descendant| descendant.send_type? || descendant.block_type? }
      .map do |callback_node|
        ast_callback = new(callback_node, model)

        # TODO add aliases and test them aswell
        next unless ast_callback.callback_method_name.to_sym.in? ActiveRecord::Callbacks::CALLBACKS

        matches = yield(ast_callback) if block_given?

        next unless matches

        ast_callback
      end.compact.uniq
    end

    def methods
      names = ast.each_child_node.map do |node|
        case node
        in :sym, method_name then method_name
        else nil
        end
      end.compact.flatten.uniq

      names.map { |name| ASTMethod.from(model, by_name: name) }
    # TODO check if there's a ces when this is needed
    # rescue NoMatchingPatternError
    #   []
    end

    # TODO extract logic to match hash conditionals?
    def condition_methods
      ast.each_child_node.map do |node|
        case node
        in :hash, *pairs
          pairs.map do |pair_node|
            case pair_node
            in [:pair, [:sym, :if | :unless], [:sym, method_name]]
              ASTMethod.from(model, by_name: method_name)
            in [:pair, [:sym, :if | :unless], [:array, *array_nodes]]
              array_nodes.select(&:sym_type?).map do |node|
                node in [:sym, method_name]
                ASTMethod.from(model, by_name: method_name)
              end
            end
          end
        else
          next
        end
      end.compact.flatten.uniq(&:ast)
    end

    def name
      callback_method_name.split('_').second.to_s
    end

    def kind
      callback_method_name.split('_').first.to_s
    end

    def callback_method_name
      ast.children.second.to_s
    end

    # TODO this is probably redundant
    def method_pattern?
      ast.send_type?
    end

    def proc_pattern?
      ast.block_type? || ast.each_child_node.all?(&:block_type?)
    end
  end
end
