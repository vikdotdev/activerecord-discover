require "activerecord_discover/railtie"
require 'helpers'
require 'association_list'
require 'validation_list'
require 'callback_list'
require 'callback'

module ActiveRecordDiscover
  CALLBACK_NAMES = %i[initialize find touch validation save create
                      update destroy commit rollback].freeze
  ENTITIES = %i[callbacks validations associations].freeze

  module ConsoleMethods
    ActiveSupport::Callbacks::CALLBACK_FILTER_TYPES.each do |kind|
      CALLBACK_NAMES.each do |name|
        next unless ActiveRecord::Callbacks::CALLBACKS.include?("#{kind}_#{name}".to_sym)

        define_method("discover_#{kind}_#{name}_callbacks_of") do |model|
          ActiveRecordDiscover::CallbackList.all(model, kind: kind, name: name)
        end
      end

      define_method("discover_#{kind}_callbacks_of") do |model|
        ActiveRecordDiscover::CallbackList.all(model, kind: kind)
      end
    end

    CALLBACK_NAMES.each do |name|
      define_method("discover_#{name}_callbacks_of") do |model|
        ActiveRecordDiscover::CallbackList.all(model, name: name)
      end
    end

    ENTITIES.each do |entity|
      define_method("discover_#{entity}_of") do |model|
        "ActiveRecordDiscover::#{entity.to_s.singularize.capitalize}List".constantize.all(model)
      end
    end
  end
end
