module ActiveRecordDiscover
  class ASTCallbackMetadata
    attr_reader :callback, :path, :method, :condition_methods

    def initialize(ast_callback, path:, ast_method: nil, ast_condition_methods: nil)
      @callback = ast_callback
      @method = ast_method
      @condition_methods = ast_condition_methods
      @path = path
    end

    def printable_targets
      targets = []
      targets << callback
      targets << method if method.present?
      targets << condition_methods

      targets.flatten
    end

    def line_length_of(target)
      target.ast.loc.last_line - target.ast.loc.first_line
    end
  end
end
