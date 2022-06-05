module DiscoverRails
  class ASTMethod
    def self.from(model, by_name: nil)
      return if by_name.nil?

      path = InstanceMethodSourceLocation.path(model, by_name)
      ast = Fast.search_file(method_pattern(by_name), path).compact.uniq.first

      new(ast, by_name)
    rescue
      new(nil, by_name)
    end

    attr_accessor :ast, :name

    def initialize(ast, name)
      @ast = ast
      @name = name
    end

    def present?
      ast.present?
    end

    def blank?
      !present?
    end

    def self.method_pattern(name)
      <<-PATTERN
        (def #{name})
      PATTERN
    end
  end
end
