module ActiveRecordDiscover
  class CallbackList
    def self.filter(model, kind: nil, name: nil)
      CallbackList.new(model, kind: kind, name: name).run
    end

    attr_reader :model, :kind, :name

    def initialize(model, kind: nil, name: nil)
      @model = model
      @kind = kind
      @name = name
    end

    def run
      paths = CallbackSourceLocation.paths(model)


      LineNumberConfiguration.reset
      LineNumberConfiguration.from_paths(paths)

      paths.map do |path|
        ast_callbacks = ASTCallback.from_file(path) do |ast_callback|
          (kind.nil? || ast_callback.kind == kind.to_s) &&
            (name.nil? || ast_callback.name == name.to_s)
        end

        ast_callbacks.map do |ast_callback|
          ASTCallbackMetadata.new(
            ast_callback,
            ast_method: ASTMethod.from(model, by_name: ast_callback.method_name),
            ast_condition_methods: ast_callback.conditions_method_names.map do |method_name|
              ASTMethod.from(model, by_name: method_name)
            end.uniq { |method| method.ast }
          )
        end.flatten
      end
    end

    private

    def callback_chains
      model.__callbacks.to_a.map do |callback_chain|
        chain_name, chain = callback_chain

        chain.instance_variable_get(:@chain).to_a
      end.flatten.compact
    end
  end
end
