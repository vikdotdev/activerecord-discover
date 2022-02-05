require 'rails_helper'

RSpec.describe ActiveRecordDiscover::CallbackPermutator do
  xcontext '.all_permutations' do
    subject do
      described_class.all_permutations do |kind, name|
        # ...
      end
    end

    let(:expected) do
      [
        # ...
      ]
    end

    describe 'includes all appropriate permutations' do
      it {
        binding.pry
        is_expected.to eq(expected)
      }
    end
  end

  # context '.kind_name_permutations' do
  #   subject do
  #     described_class.kind_name_permutations
  #   end
  #
  #   describe 'includes all appropriate permutations' do
  #   end
  # end
end
