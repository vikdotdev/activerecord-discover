require 'rails_helper'

RSpec.describe ConsoleMethods do
  class DummyConsoleEnvironment
    include ConsoleMethods
  end

  let(:dummy_console_env) { DummyConsoleEnvironment.new }

  describe 'outputs when entity list is empty' do
    describe "when constant is not model" do
      it 'prints that class is not an ActiveRecord::Base ancestor' do
        assert_output(/is not an ActiveRecord::Base ancestor/) do
          dummy_console_env.discover_callbacks_of(dummy_klass)
        end

        assert_output(/is not an ActiveRecord::Base ancestor/) do
          dummy_console_env.discover_validations_of(dummy_klass)
        end
      end
    end

    describe "when constant is a model" do
      context 'when callbacks' do
        it 'prints that no callbacks were found' do
          assert_output(/No callbacks found/) do
            dummy_console_env.discover_callbacks_of(dummy_model)
          end
        end
      end
      context 'when validations' do
        it 'prints that no validations were found' do
          assert_output(/No validations found/) do
            dummy_console_env.discover_validations_of(dummy_model)
          end
        end
      end
    end
  end

  describe 'console methods' do
    PermutationHelper.callback_pairs.each do |kind, name|
      it "responds with #{kind} and #{name}" do
        assert_respond_to dummy_console_env, "discover_#{kind}_#{name}_callbacks_of"
      end
    end
  end
end
