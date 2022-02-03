module ActiveRecordDiscover
  class ASTCallback
    attr_accessor :ast

    def self.from_string(string)
      new(Fast.ast(string))
    end

    def self.from_file(path, &block)
      Fast.search_file(callback_pattern, path).map do |ast|
        ast_callback = new(ast)
        matches = yield(ast_callback) if block_given?

        next unless matches

        ast_callback
      end.compact.uniq
    end

    def initialize(ast)
      @ast = ast
    end

    def match?
      Fast.match?(self.class.callback_pattern, ast)
    end

    def method?
      Fast.match?(self.class.method_pattern, ast)
    end

    def method_name
      # ... implement a method that is going to fetch callback method source
    end

    def proc?
      Fast.match?(self.class.proc_pattern, ast)
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
              (sym { if unless on })
              ({ sym array block } { _ ... }))))
      PATTERN
    end

    def self.method_pattern
      <<-PATTERN
        (send nil { #{existing_callbacks} }
          (sym _))
      PATTERN
    end

    def self.proc_pattern
      <<-PATTERN
        (send nil { #{existing_callbacks} }
          (block ...))
      PATTERN
    end

    def self.existing_callbacks
      ActiveRecord::Callbacks::CALLBACKS.join(' ')
    end

    def self.existing_kinds
      ActiveSupport::Callbacks::CALLBACK_FILTER_TYPES.join(' ')
    end
  end
end
