module ActiveRecordDiscover
  class ASTValidation
    include ASTValidationPatterns
    extend ASTValidationPatterns

    def self.from_path(path, model)
      ASTValidationPatterns::PATTERNS.flat_map do |pattern|
        Fast.search_file(pattern, path).map do |ast|
          new(ast, model)
        end
      end.compact.uniq.sort
    end

    attr_reader :ast, :model

    def initialize(ast, model)
      @ast = ast
      @model = model
    end

    def methods
      return [] unless validate_pattern?

      method_names = methods_parent_node.map do |node|
        Fast.capture('(sym $_)', node)&.first
      end.compact

      method_names.map do |method_name|
        ASTMethod.from(model, by_name: method_name)
      end.compact.uniq(&:ast)
    end

    def condition_methods
      condition_methods_parent_node.flat_map do |hash|
        hash.child_nodes.select(&:pair_type?).flat_map do |pair|
          key, value = pair.child_nodes

          next unless Fast.match?('(sym { if unless })', key)

          Fast.capture('(sym $_)', value).flat_map do |method_name|
            ASTMethod.from(model, by_name: method_name)
          end
        end
      end.compact.uniq(&:ast)
    end

    def match?
      pattern.present?
    end

    def as_printable
      @as_printable ||= [self, methods, condition_methods].flatten
    end

    def <=>(other)
      ast.loc.first_line <=> other.ast.loc.first_line
    end

    private

    def methods_parent_node
      if ast.block_type?
        ast.child_nodes.flat_map { |node| node.child_nodes.reject(&:hash_type?) }
      else
        ast.child_nodes.reject(&:hash_type?)
      end
    end

    def condition_methods_parent_node
      if validates_each_pattern?
        ast.child_nodes.first.child_nodes.select(&:hash_type?)
      elsif validate_pattern? && ast.block_type?
        ast.child_nodes.flat_map { |node| node.child_nodes.select(&:hash_type?) }
      else
        ast.child_nodes.select(&:hash_type?)
      end
    end
  end
end
