module ActiveRecordDiscover
  module ConsoleMethods
    # TODO: move out of console methods
    def print_callbacks(model, kind: nil, name: nil)
      ActiveRecordDiscover::CallbackPrinter.print(
        ActiveRecordDiscover::CallbackFormatter.from_pairs(
          ActiveRecordDiscover::CallbackList.filter(model, kind: kind, name: name)
        )
      )
    end

    # def print_entity(model, kind: nil, name: nil)
    #   ActiveRecordDiscover::CallbackPrinter.print(
    #     ActiveRecordDiscover::CallbackFormatter.from_pairs(
    #       ActiveRecordDiscover::CallbackList.filter(model, kind: kind, name: name)
    #     )
    #   )
    # end

    ActiveSupport::Callbacks::CALLBACK_FILTER_TYPES.each do |kind|
      CALLBACK_NAMES.each do |name|
        next unless ActiveRecord::Callbacks::CALLBACKS.include?("#{kind}_#{name}".to_sym)

        define_method("discover_#{kind}_#{name}_callbacks_of") do |model|
          print_callbacks(model, kind: kind, name: name)
        end
      end

      define_method("discover_#{kind}_callbacks_of") do |model|
        print_callbacks(model, kind: kind)
      end
    end

    CALLBACK_NAMES.each do |name|
      define_method("discover_#{name}_callbacks_of") do |model|
        print_callbacks(model, name: name)
      end
    end

    ENTITIES.each do |entity|
      define_method("discover_#{entity}_of") do |model|
        "ActiveRecordDiscover::#{entity.to_s.singularize.capitalize}Formatter".constantize.from_pairs(
          "ActiveRecordDiscover::#{entity.to_s.singularize.capitalize}List".constantize.filter(model)
        )
      end
    end
  end
end
