module ActiveRecordDiscover
  # TODO add validation list base enumerable class?
  class ASTValidationList
    def self.find(model)
      ASTValidationList.new(model).run
    end

    attr_reader :model

    def initialize(model)
      @model = model
      @items = []
    end

    def run
      # TODO works for validations? rename?
      paths = CallbackSourceLocation.paths(model)

      LineNumberConfiguration.reset
      LineNumberConfiguration.from_paths(paths)

      @items = paths.flat_map do |path|
        ast_validations = ASTValidation.from_path(path, model)

        ast_validations.map do |ast_validation|
          ASTValidationGroup.new(ast_validation)
        end
      end.compact.uniq
    end
  end
end
