module ActiveRecordDiscover
  class SourceLocationBase
    attr_reader :model

    def initialize(model)
      @model = model
    end
  end

  class InstanceMethodSourceLocation < SourceLocationBase
    def self.path(model, method_name)
      new(model).instance_method_path(method_name)
    end

    def instance_method_path(name)
      model.instance_method(name).source_location&.first
    end
  end

  class CallbackSourceLocation < SourceLocationBase
    def self.paths(model)
      new(model).paths
    end

    def paths
      [source_location_of(model)] + include_paths
    end

    private

    def include_paths
      includes = model.ancestors.take_while { |ancestor| ancestor != model.superclass }
      application_includes = includes.select { |ancestor| ancestor.instance_of?(Module) }

      application_includes.map do |ancestor|
        begin
          path = source_location_of(ancestor)

          next unless path.include?(Rails.root.to_s)
        rescue NameError
          next
        end

        path
      end.compact
    end

    def source_location_of(constant)
      ActiveRecord::Base.const_source_location(constant.to_s)&.first
    end
  end
end
