module ActiveRecordDiscover
  class PrintWrapper
    def self.print(model, kind: nil, name: nil)
      unless model.ancestors.include?(ActiveRecord::Base)
        puts "\"#{model}\" is not an ActiveRecord::Base ancestor."
        return
      end

      ActiveRecordDiscover::Printer.print(
        ActiveRecordDiscover::CallbackList.filter(model, kind: kind, name: name)
      )

      nil
    end
  end

  module ConsoleMethods
    Permutator.callback_pairs.map do |kind, name|
      define_method("discover_#{kind}_#{name}_callbacks_of") do |model|
        PrintWrapper.print(model, kind: kind, name: name)
      end
    end

    Permutator.callback_kinds.map do |kind|
      define_method("discover_#{kind}_callbacks_of") do |model|
        PrintWrapper.print(model, kind: kind)
      end
    end

    Permutator.callback_names.map do |name|
      define_method("discover_#{name}_callbacks_of") do |model|
        PrintWrapper.print(model, name: name)
      end
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
