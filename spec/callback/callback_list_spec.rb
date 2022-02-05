require 'rails_helper'

RSpec.describe ActiveRecordDiscover::CallbackList do
  describe 'all callbacks' do
    [Simple, WithOption].each do |model|
      subject { described_class.filter(model) }

      it { is_expected.to be_an(Array) }
      it { is_expected.to include(path_asts_pair) }

      # TODO: test when no kind or no name
      ActiveSupport::Callbacks::CALLBACK_FILTER_TYPES.each do |kind|
        ActiveRecordDiscover::CALLBACK_NAMES.each do |name|
          next unless ActiveRecord::Callbacks::CALLBACKS.include?("#{kind}_#{name}".to_sym)

          context "when name #{name}" do
            subject { described_class.filter(model, name: name) }

            it { is_expected.to include(callback_of_name(name)) }

            describe "of kind #{kind}" do
              subject { described_class.filter(model, kind: kind, name: name) }

              it { is_expected.to include(callback_of_kind(kind)) }
              it { is_expected.to include(callback_of_name(name)) }
            end
          end
        end
      end
    end
  end
end
