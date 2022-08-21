module ActiveRecordDiscover

  # TODO rename all these ? to exclude AST
  class ASTCallback < ASTEntity

    def self.from_path(path, model)
      EntityBuilder.new(AST.from_path(path), CallbackMatcher).call.map do |node|
        callback = new(node, model)

        # TODO add aliases and test them aswell
        next unless callback.callback_method_name.to_sym.in? ActiveRecord::Callbacks::CALLBACKS

        matches = yield(callback) if block_given?

        next unless matches

        callback
      end.compact.uniq.sort
    end

    def argument_methods
      ArgumentMethodExtractor.new(send_node).call.map do |name|
        ASTMethod.from(model, by_name: name)
      end
    end

    def hash_methods
      HashMethodExtractor.new(send_node).call.map do |name|
        ASTMethod.from(model, by_name: name)
      end.uniq(&:ast)
    end

    # TODO find a better way to extract this
    # this also breaks block types from showing up in the list
    # now fixed - add tests for regular block types
    def name
      callback_method_name.split('_').second.to_s
    end

    def kind
      callback_method_name.split('_').first.to_s
    end

    def callback_method_name
      send_node.children.second.to_s
    end
  end
end
