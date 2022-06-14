module ActiveRecordDiscover
  class ASTCallbackList < ASTEntityList
    attr_reader :kind, :name

    def initialize(model, kind: nil, name: nil)
      super(model)

      @kind = kind
      @name = name
    end

    def run
      paths = ClassSourceLocation.paths(model)

      LineNumberConfiguration.reset
      LineNumberConfiguration.from_paths(paths)

      @entities = paths.flat_map do |path|
        ASTCallback.from_path(path, model) do |ast_callback|
          (kind.nil? || ast_callback.kind == kind.to_s) && (name.nil? || ast_callback.name == name.to_s)
        end
      end.compact.uniq
    end
  end
end
