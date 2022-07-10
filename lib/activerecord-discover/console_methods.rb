module ActiveRecordDiscover
  module ConsoleMethods
    PermutationHelper.callback_pairs.map do |kind, name|
      define_method("discover_#{kind}_#{name}_callbacks_of") do |model|
        Printer.print_all(ASTCallbackList.find(model, kind: kind, name: name))
      end
    end

    PermutationHelper.callback_kinds.map do |kind|
      define_method("discover_#{kind}_callbacks_of") do |model|
        Printer.print_all(ASTCallbackList.find(model, kind: kind))
      end
    end

    PermutationHelper.callback_names.map do |name|
      define_method("discover_#{name}_callbacks_of") do |model|
        Printer.print_all(ASTCallbackList.find(model, name: name))
      end
    end

    def discover_callbacks_of(model)
      Printer.print_all(ASTCallbackList.find(model))
    end

    def discover_validations_of(model)
      Printer.print_all(ASTValidationList.find(model))
    end
  end
end
