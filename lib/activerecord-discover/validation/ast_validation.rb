module ActiveRecordDiscover
  class ASTValidation < ASTEntity
    # include ASTValidationPatterns
    # extend ASTValidationPatterns
    VALIDATION_METHODS = %w[
      validate validates validates! validates_absence_of validates_acceptance_of
      validates_associated validates_confirmation_of validates_exclusion_of
      validates_format_of validates_inclusion_of validates_length_of
      validates_numericality_of validates_presence_of validates_size_of
      validates_uniqueness_of validates_each validates_with
    ].freeze

    def self.from_path(path, model)
      # binding.pry
      # TODO add some sort of depup functionality or use a pattern??????????
      AST.from_path(path).descendants
      .select { |descendant| descendant.send_type? || descendant.block_type? }
      .combination(2)
      .map do |(current, other)|
        one = includes_inner?(current, other)
        two = includes_inner?(other, current)
        next if !one && !two

        case [one, two]
          when [true, false] then current
          when [false, true] then other
        end
      end
      .compact
      .map do |validation_node|
        ast_validation = new(validation_node, model)

        # TODO this causes block types to fail
        # next unless ast_validation.validation_method_name.in? VALIDATION_METHODS

        ast_validation
      end.compact.uniq.sort
    end

    def self.includes_inner?(outer, inner)
      outer.descendants.any? { |descendant| descendant == inner }
    end

    def methods
      # TODO: improve
      binding.pry
      return [] unless validation_method_name == 'validate'

      names = ast.each_child_node.map do |node|
        case node
        in :sym, method_name then method_name
        else nil
        end
      end.compact.flatten.uniq

      names.map { |name| ASTMethod.from(model, by_name: name) }
    end

    def condition_methods
      ast.each_child_node.map do |node|
        case node
        in :hash, *pairs
          pairs.map do |pair_node|
            case pair_node
            in [:pair, [:sym, :if | :unless], [:sym, method_name]]
              ASTMethod.from(model, by_name: method_name)
            in [:pair, [:sym, :if | :unless], [:array, *array_nodes]]
              array_nodes.select(&:sym_type?).map do |node|
                node in [:sym, method_name]
                ASTMethod.from(model, by_name: method_name)
              end
            else
              next
            end
          end
        else
          next
        end
      end.flatten.compact.uniq(&:ast)
    end

    def validation_method_name
    # go from low level patten then go up to the parent
      # binding.pry
      ast.children.second.to_s
    end
  end
end
