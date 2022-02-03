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
      paths = callback_chains.map do |callback_chain|
        ActiveRecordDiscover::CallbackSourceLocation.find(callback_chain, model)
      end.compact.uniq

      paths.map do |path|
        callbacks = ASTCallback.from_file(path) do |ast_callback|
          (kind.nil? || ast_callback.kind == kind.to_s) &&
            (name.nil? || ast_callback.name == name.to_s)
        end

        [path, callbacks]
      end
    end

    def callback_chains
      model.__callbacks.to_a.map do |callback_chain|
        chain_name, chain = callback_chain

        chain.instance_variable_get(:@chain).to_a
      end.flatten.compact
    end
  end
end
