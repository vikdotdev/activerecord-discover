module ActiveRecordDiscover
  class CallbackSourceLocation
    def self.paths(model)
      new(model).paths
    end

    attr_reader :model

    def initialize(model)
      @model = model
    end

    def paths
      [source_location_of(model)] + include_paths
    end

    private

    def include_paths
      includes = model.ancestors.take_while { |ancestor| ancestor != model.superclass }
      application_includes = includes.select { |ancestor| ancestor.instance_of?(Module) }

      application_includes.map do |ancestor|
        path = source_location_of(ancestor)

        next unless path.include?(Rails.root.to_s)

        path
      end.compact
    end

    def source_location_of(constant)
      ActiveRecord::Base.const_source_location(constant.to_s)&.first
    end
  end
end
