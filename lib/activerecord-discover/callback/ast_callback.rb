module ActiveRecordDiscover
  class ASTCallback < ASTEntity
    include ASTCallbackPatterns
    extend ASTCallbackPatterns
    extend RuboCop::AST::NodePattern::Macros

    def self.from_path(path, model)

      # named = RuboCop::AST::NodePattern.new '(send _ %method ...)'
      #
      # named.match(ast_from("hello"), method: /hell/)
      AST.search_path(CALLBACK_PATTERN, path).map do |ast|
        ast_callback = new(ast, model)
        matches = yield(ast_callback) if block_given?

        next unless matches

        ast_callback
      end.compact.uniq
      # binding.pry
      # Fast.search_file(CALLBACK_PATTERN, path).map do |ast|
      #   ast_callback = new(ast, model)
      #   matches = yield(ast_callback) if block_given?
      #
      #   next unless matches
      #
      #   ast_callback
      # end.compact.uniq
    end

    # def self.fast_from_path(path, model)
    #   Fast.search_file(CALLBACK_PATTERN, path).map do |ast|
    #     ast_callback = new(ast, model)
    #     matches = yield(ast_callback) if block_given?
    #
    #     next unless matches
    #
    #     ast_callback
    #   end.compact.uniq
    # end

    def match?
      # puts
      # puts CALLBACK_PATTERN
      # puts
      # puts ast
      # puts
      # puts ast.source
      # puts
      # # binding.pry
      AST.pattern(CALLBACK_PATTERN).match(ast)
      # Fast.match?(CALLBACK_PATTERN, ast)
    end

    def methods
      return [] unless method_pattern?

      binding.pry
      Array.wrap(AST.pattern(CALLBACK_METHOD_PATTERN).match(ast)).map do |method_name|
        ASTMethod.from(model, by_name: method_name)
      end
      # Fast.capture(CALLBACK_METHOD_PATTERN, ast).map do |method_name|
      #   ASTMethod.from(model, by_name: method_name)
      # end
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
      # Fast.capture('$(hash ...)', ast).map do |node|
      AST.search('$(hash ...)', ast).map do |node|
        node.children.map do |child|
          key_ast, conditions_ast = child.children

          # binding.pry
          # if Fast.match?('(sym { if unless })', key_ast) && conditions = Fast.capture('(sym $_)', conditions_ast)
          if AST.pattern('(sym { :if :unless })').match(key_ast) && conditions = AST.search('(sym $_)', conditions_ast)
            # conditions

            conditions.map(&:to_a).flatten
          end
        end
      end.flatten.compact
    end

  end
end
