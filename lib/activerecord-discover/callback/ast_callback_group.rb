module ActiveRecordDiscover
  class ASTCallbackGroup
    attr_reader :callback, :method, :condition_methods

    def initialize(ast_callback, ast_method: nil, ast_condition_methods: nil)
      @callback = ast_callback
      @method = ast_method
      @condition_methods = ast_condition_methods
    end

    def printable_targets
      targets = []
      targets << callback
      targets << method if method.present?
      targets << condition_methods

      targets.flatten
    end
  end
end
