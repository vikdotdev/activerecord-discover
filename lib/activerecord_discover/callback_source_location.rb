module ActiveRecordDiscover
  class CallbackSourceLocation

    def self.find(active_record_callback, model)
      new(active_record_callback, model).find
    end

    attr_reader :active_record_callback, :model

    def initialize(active_record_callback, model)
      @active_record_callback = active_record_callback
      @model = model
    end

    def find
      if method? && model.instance_methods.include?(filter)
        model.instance_method(filter)&.source_location&.first
      elsif proc?
        filter.source_location.first
      end
    end

    private

    def method?
      filter.is_a?(Symbol)
    end

    def proc?
      filter.is_a?(Proc)
    end

    def filter
      active_record_callback.instance_variable_get(:@filter)
    end
  end
end
