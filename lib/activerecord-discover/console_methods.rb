module ActiveRecordDiscover
  class PrintWrapper
    def self.print(model, kind: nil, name: nil)
      unless model.ancestors.include?(ActiveRecord::Base)
        puts "\"#{model}\" is not an ActiveRecord::Base ancestor."
        return
      end

      ActiveRecordDiscover::Printer.print_all(
        ActiveRecordDiscover::ASTCallbackGroupList.filter(model, kind: kind, name: name)
      )

      nil
    end
  end

  module ConsoleMethods
    PermutationHelper.callback_pairs.map do |kind, name|
      define_method("discover_#{kind}_#{name}_callbacks_of") do |model|
        PrintWrapper.print(model, kind: kind, name: name)
      end
    end

    PermutationHelper.callback_kinds.map do |kind|
      define_method("discover_#{kind}_callbacks_of") do |model|
        PrintWrapper.print(model, kind: kind)
      end
    end

    PermutationHelper.callback_names.map do |name|
      define_method("discover_#{name}_callbacks_of") do |model|
        PrintWrapper.print(model, name: name)
      end
    end

    def discover_callbacks_of(model)
      PrintWrapper.print(model)
    end

    def discover_validations_of(model)
      ActiveRecordDiscover::Printer.print_all(
        ActiveRecordDiscover::ASTValidationList.find(model)
      )

      nil
    end

    # ENTITIES.each do |entity|
    #   define_method("discover_#{entity}_of") do |model|
    #     ActiveRecordDiscover::BaseFormatter.from_pairs(
    #       "ActiveRecordDiscover::#{entity.to_s.singularize.capitalize}List".constantize.filter(model)
    #     )
    #   end
    # end
  end
end
