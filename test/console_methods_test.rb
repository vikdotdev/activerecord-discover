require 'test_helper'


module ActiveRecordDiscover
  class DummyConsoleEnvironment
    include ConsoleMethods
  end

  class ConsoleMethodsTest < ActiveSupport::TestCase
    dummy_console_env = DummyConsoleEnvironment.new

    PermutationHelper.callback_pairs.each do |kind, name|
      test "console methods responding with #{kind} and #{name}" do
        assert_respond_to dummy_console_env, "discover_#{kind}_#{name}_callbacks_of"
      end
    end
  end
end
