module ActiveRecordDiscover
  class ASTCallback < ASTEntity
    include ASTCallbackPatterns
    extend ASTCallbackPatterns

    def self.from_path(path, model)
      Fast.search_file(CALLBACK_PATTERN, path).map do |ast|
        ast_callback = new(ast, model)
        matches = yield(ast_callback) if block_given?

        next unless matches

        ast_callback
      end.compact.uniq
    end

    def match?
      Fast.match?(CALLBACK_PATTERN, ast)
    end

    def methods
      return [] unless method_pattern?

      Fast.capture(CALLBACK_METHOD_PATTERN, ast).map do |method_name|
        ASTMethod.from(model, by_name: method_name)
      end
    end

    def condition_methods
      conditions_method_names.map do |method_name|
        ASTMethod.from(model, by_name: method_name)
      end.uniq(&:ast)
    end

    def name
      callback_symbol.split('_').second.to_s
    end

    def kind
      callback_symbol.split('_').first.to_s
    end

    private

    def callback_symbol
      Fast.capture('(send nil $_)', ast).first.to_s
    end

    def conditions_method_names
      Fast.capture('$(hash ...)', ast).map do |node|
        node.children.map do |child|
          key_ast, conditions_ast = child.children

          if Fast.match?('(sym { if unless })', key_ast) && conditions = Fast.capture('(sym $_)', conditions_ast)
            conditions
          end
        end
      end.flatten.compact
    end

  end
end
