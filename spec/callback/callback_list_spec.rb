require 'rails_helper'

RSpec.describe ActiveRecordDiscover::CallbackList do
  describe 'all callbacks' do
    [Alpha, Beta].each do |model|
      subject { described_class.filter(model) }

      it { is_expected.to be_an(Array) }
      it { is_expected.to include(ast_callback_metadata) }

      # TODO: test when no kind or no name
      ActiveRecordDiscover::Permutator.callback_pairs.map do |kind, name|
        context "when name #{name}" do
          subject { described_class.filter(model, name: name) }

          it { is_expected.to include(ast_callback_metadata_with_callback_of_name(name)) }

          describe "of kind #{kind}" do
            subject { described_class.filter(model, kind: kind, name: name) }

            it { is_expected.to include(ast_callback_metadata_with_callback_of_kind(kind)) }
            it { is_expected.to include(ast_callback_metadata_with_callback_of_name(name)) }
          end
        end
      end
    end
  end
end
