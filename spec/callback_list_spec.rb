require 'rails_helper'

RSpec.describe ActiveRecordDiscover::CallbackList do
  describe 'all callbacks' do
    let!(:model) { AllCallbacks }
    subject { described_class.all(model) }

    it { is_expected.to be_an(Array) }
    it { is_expected.to include(a_kind_of(ActiveRecordDiscover::Callback)) }

    ActiveSupport::Callbacks::CALLBACK_FILTER_TYPES.each do |kind|
      ActiveRecordDiscover::CALLBACK_NAMES.each do |name|
        next unless ActiveRecord::Callbacks::CALLBACKS.include?("#{kind}_#{name}".to_sym)

        let!(:model) { AllCallbacks }

        context "when name #{name}" do
          subject { described_class.all(model, name: name) }

          it { is_expected.to include(a_callback_of_a_name(name)) }

          describe "of kind #{kind}" do
            subject { described_class.all(model, kind: kind, name: name) }

            it { is_expected.to include(a_callback_of_a_kind(kind)) }
            it { is_expected.to include(a_callback_of_a_name(name)) }
          end
        end
      end
    end
  end

  describe 'with if conditions' do
    let!(:model) { IfCondition }

    subject do
      described_class.all(model, kind: :before, name: :save).select do |callback|
        callback.filter == method_name
      end
    end

    context 'when symbolic' do
      let!(:method_name) { :symbolic_if }

      it { is_expected.to include(a_callback_including_symbolic_if(:if_cond)) }

      context 'when multiple' do
        let!(:method_name) { :symbolic_if_multiple }
        it { is_expected.to include(a_callback_including_symbolic_if(:if_cond,
                                                                     :if_cond2)) }
      end
    end

    context 'when proc' do
      let!(:method_name) { :proc_if }
      let!(:source) { '__proc_if_1__' }

      it { is_expected.to include(callback_including_proc_source(source)) }

      context 'when multiple callbacks' do
        let!(:method_name) { :proc_if_multiple }
        let!(:source) { %w[__proc_if_2__ __proc_if_3__] }
        it { is_expected.to include(callback_including_proc_source(*source)) }
      end

      xcontext 'when multiple callbacks 2' do
        subject do
          described_class.all(model, kind: :before, name: :save).select do |callback|
            callback.filter == method_name
          end.each { |callback| callback.proc_ifs.each(&:source) }
        end
        let!(:method_name) { :proc_if_multiple2 }
        let!(:source) { %w[__proc_if_4__ __proc_if_5__] }
        it { expect { subject }.not_to raise_error(MethodSource::SourceNotFoundError) }
      end
    end
  end
end
