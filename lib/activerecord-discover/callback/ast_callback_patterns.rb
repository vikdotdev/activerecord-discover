module ActiveRecordDiscover
  module ASTCallbackPatterns
    METHODS = ":#{ActiveRecord::Callbacks::CALLBACKS.join(' :')}".freeze
    # CALLBACK_PATTERN = <<-PATTERN.freeze
    #   ({ (block (send nil { #{ActiveRecord::Callbacks::CALLBACKS.join(' ')} }))
    #      (send nil { #{ActiveRecord::Callbacks::CALLBACKS.join(' ')} }
    #        ({ block sym } { _ ...})) })
    # PATTERN
    # CALLBACK_PATTERN = <<-PATTERN.freeze
    #   (send nil? { :#{ActiveRecord::Callbacks::CALLBACKS.join(' :')} }
    #     ({ block sym } _))
    # PATTERN
    # CALLBACK_PATTERN = <<-PATTERN.freeze
    #   (block (send nil? { #{METHODS} }))
    # PATTERN


    # CALLBACK_PATTERN = <<-PATTERN.freeze
    #   { (block (send nil? { #{METHODS} }) ...)
    #     (send nil? { #{METHODS} } #has_symbol_or_block_arguments? ) }
    # PATTERN
    CALLBACK_PATTERN = <<-PATTERN.freeze
    { (block (send nil? { #{METHODS} } ({ block sym hash } ...) *) ... )
        (send nil? { #{METHODS} } ({ block sym hash } ...) +) }
    PATTERN
    CALLBACK_METHOD_PATTERN = <<-PATTERN.freeze
      (send nil? { #{METHODS} } $(sym _) + ...)
    PATTERN
    CALLBACK_PROC_PATTERN = <<-PATTERN.freeze
      (send nil? { #{METHODS} } (block ...) ...)
    PATTERN

    def method_pattern?
      # Fast.match?(CALLBACK_METHOD_PATTERN, ast)
      AST.pattern(CALLBACK_METHOD_PATTERN).match(ast).present?
    end

    def proc_pattern?
      # Fast.match?(CALLBACK_PROC_PATTERN, ast)
      AST.pattern(CALLBACK_PROC_PATTERN).match(ast)
    end

    def rb_method_pattern?
    end
  end
end
