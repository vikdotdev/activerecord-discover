module ActiveRecordDiscover
  module ASTCallbackPatterns
    CALLBACK_PATTERN = <<-PATTERN.freeze
      ({ (block (send nil { #{ActiveRecord::Callbacks::CALLBACKS.join(' ')} }))
         (send nil { #{ActiveRecord::Callbacks::CALLBACKS.join(' ')} }
           ({ block sym } { _ ...})) })
    PATTERN
    CALLBACK_METHOD_PATTERN = <<-PATTERN.freeze
      (send nil { #{ActiveRecord::Callbacks::CALLBACKS.join(' ')} }
        (sym $_))
    PATTERN
    CALLBACK_PROC_PATTERN = <<-PATTERN.freeze
      (send nil { #{ActiveRecord::Callbacks::CALLBACKS.join(' ')} }
        (block ...))
    PATTERN

    def method_pattern?
      Fast.match?(CALLBACK_METHOD_PATTERN, ast)
    end

    def proc_pattern?
      Fast.match?(CALLBACK_PROC_PATTERN, ast)
    end
  end
end
