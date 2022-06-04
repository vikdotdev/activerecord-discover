module ActiveRecordDiscover
  class ASTCallback
    def self.from_file(path, &block)
      Fast.search_file(callback_pattern, path).map do |ast|
        ast_callback = new(ast)
        matches = yield(ast_callback) if block_given?

        next unless matches

        ast_callback
      end.compact.uniq
    end

    attr_accessor :ast

    def initialize(ast)
      @ast = ast
    end

    def match?
      Fast.match?(self.class.callback_pattern, ast)
    end

    def method?
      pattern = <<-PATTERN
        (send nil { #{self.class.existing_callbacks} }
          (sym _))
      PATTERN

      Fast.match?(pattern, ast)
    end

    def method_name
      return unless method?

      pattern = <<-PATTERN
        (send nil { #{self.class.existing_callbacks} }
          (sym $_))
      PATTERN

      Fast.capture(pattern,  ast)&.first
    end

    def conditions_method_names
      Fast.capture('$(hash ...)', ast).map do |node|
        node.children.map do |child|
          key_ast, conditions_ast = child.children

          if Fast.match?('(sym { if unless })', key_ast) &&
            conditions = Fast.capture('(sym $_)', conditions_ast)
            conditions
          end
        end
      end.flatten.compact
    end

    def proc?
      pattern = <<-PATTERN
        (send nil { #{self.class.existing_callbacks} }
          (block ...))
      PATTERN

      Fast.match?(pattern, ast)
    end

    def name
      Fast.capture('(send nil $_)', ast).first.to_s.split('_').second.to_s
    end

    def kind
      Fast.capture('(send nil $_)', ast).first.to_s.split('_').first.to_s
    end

    def self.callback_pattern
      <<-PATTERN
        (send nil { #{existing_callbacks} }
          ({ block sym } { _ ...})
          ?(hash
            (pair
              (sym _)
              ({ sym array block } { _ ... }))))
      PATTERN
    end

    def self.existing_callbacks
      ActiveRecord::Callbacks::CALLBACKS.join(' ')
    end
  end
end
