require "test_helper"

module ActiveRecordDiscover
  class PrintWrapperTest < ActiveSupport::TestCase
    describe "when constant is not model" do
      it 'prints that class is not an ActiveRecord::Base ancestor' do
        dummy_klass = Class.new
        Object.const_set 'DummyKlass', dummy_klass

        assert_output(/is not an ActiveRecord::Base ancestor/) do
          PrintWrapper.print(dummy_klass)
        end
      end
    end

    describe "when constant is a model" do
      it 'prints that no callbacks were found' do
        dummy_model = Class.new(ActiveRecord::Base)
        Object.const_set 'DummyModel', dummy_model

        assert_output(/No callbacks found/) { PrintWrapper.print(dummy_model) }
      end
    end
  end
end

