module ActiveRecordDiscover
  class ASTValidationList < ASTEntityList
    def run
      paths = ClassSourceLocation.paths(model)

      LineNumberConfiguration.reset
      LineNumberConfiguration.from_paths(paths)

      @entities = paths.flat_map { |path| ASTValidation.from_path(path, model) }.compact.uniq
    end
  end
end
