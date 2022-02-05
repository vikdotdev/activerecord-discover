def print_callbacks(model, kind: nil, name: nil)
  ActiveRecordDiscover::Printer.print(
    ActiveRecordDiscover::CallbackList.filter(model, kind: kind, name: name)
  )

  nil
end

module ActiveRecordDiscover
  module ConsoleMethods
    Permutator.callback_pairs.map do |kind, name|
      define_method("discover_#{kind}_#{name}_callbacks_of") do |model|
        print_callbacks(model, kind: kind, name: name)
      end
    end

    Permutator.callback_kinds.map do |kind|
      define_method("discover_#{kind}_callbacks_of") do |model|
        print_callbacks(model, kind: kind)
      end
    end

    Permutator.callback_names.map do |name|
      define_method("discover_#{name}_callbacks_of") do |model|
        print_callbacks(model, name: name)
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
