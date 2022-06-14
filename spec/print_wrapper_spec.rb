require 'rails_helper'

RSpec.describe PrintWrapper do
  describe "when constant is not model" do
    it 'prints that class is not an ActiveRecord::Base ancestor' do
      assert_output(/is not an ActiveRecord::Base ancestor/) do
        PrintWrapper.print(dummy_klass)
      end
    end
  end

  describe "when constant is a model" do
    it 'prints that no callbacks were found' do
      assert_output(/No callbacks found/) { PrintWrapper.print(dummy_model) }
    end
  end
end
