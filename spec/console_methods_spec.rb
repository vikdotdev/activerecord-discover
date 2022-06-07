require 'rails_helper'

RSpec.describe ConsoleMethods do
  class DummyConsoleEnvironment
    include ConsoleMethods
  end

  describe 'console methods' do
    let(:dummy_console_env) { DummyConsoleEnvironment.new }

    PermutationHelper.callback_pairs.each do |kind, name|
      it "responds with #{kind} and #{name}" do
        assert_respond_to dummy_console_env, "discover_#{kind}_#{name}_callbacks_of"
      end
    end
  end
end
