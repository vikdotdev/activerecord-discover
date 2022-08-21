module ActiveRecordDiscover
  class ASTMethod
    def self.from(model, by_name: nil)
      return if by_name.nil?

      path = InstanceMethodSourceLocation.path(model, by_name)

      # TODO add variants for both ruby 2.7 and ruby 3? How?
      ast = AST.from_path(path).descendants.select do |node|
        next unless node.def_type?

        # TODO improve
        case node
        in [:def, name, *_] then name if name == by_name
        else nil
        end
      end.compact.first

      new(ast, by_name)
    end

    attr_accessor :ast, :name

    def initialize(ast, name)
      @ast = ast
      @name = name
    end
  end
end
