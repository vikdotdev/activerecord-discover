module ActiveRecordDiscover
  class ASTMethod
    def self.from(model, by_name: nil)
      return if by_name.nil?

      path = model.instance_method(by_name).source_location.first
      ast = Fast.search_file(method_pattern(by_name), path).map { |ast| ast }.compact.uniq.first

      new(ast)
    end

    attr_accessor :ast

    def initialize(ast)
      @ast = ast
    end

    def present?
      ast.present?
    end

    def self.method_pattern(name)
      <<-PATTERN
        (def #{name})
      PATTERN
    end
  end
end
