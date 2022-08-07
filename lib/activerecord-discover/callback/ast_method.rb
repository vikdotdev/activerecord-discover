require 'forwardable'

module ActiveRecordDiscover
  # attr_accessor :records
  # extend Forwardable
  # def_delegator :@ast, :present?, :blank?

  class ASTMethod
    def self.from(model, by_name: nil)
      return if by_name.nil?

      path = InstanceMethodSourceLocation.path(model, by_name)
      # ast = Fast.search_file(method_pattern(by_name), path).compact.uniq.first

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
      # TODO check if there's a ces when this is needed
    # rescue
    #   new(nil, by_name)
    end

    attr_accessor :ast, :name

    def initialize(ast, name)
      @ast = ast
      @name = name
    end

    # TODO delegate :present? to ast ? is it even needed?
    # def present?
    #   ast.present?
    # end
    #
    # def blank?
    #   !present?
    # end
  end
end
