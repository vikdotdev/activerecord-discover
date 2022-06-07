module DummyConstantHelper
  def dummy_model
    return @@dummy_model if defined?(@@dummy_model)

    klass_name = 'DummyModel'
    @@dummy_model = Class.new(ActiveRecord::Base)

    Object.const_set klass_name, @@dummy_model
  end

  def dummy_klass
    return @@dummy_klass if defined?(@@dummy_klass)

    klass_name = 'DummyKlass'
    @@dummy_klass = Class.new

    Object.const_set klass_name, @@dummy_klass
  end
end
