require 'test_helper'

# TODO use for console methods?
# config.before(:suite) { PrintSquelch.squelch_output }
# config.after(:suite) { PrintSquelch.unsquelch_output }

# TODO rewrite to minitest
RSpec.xdescribe 'Console methods' do
  include ActiveRecordDiscover::ConsoleMethods

  let!(:callback_list_class) { ActiveRecordDiscover::CallbackList }
  let!(:model) { Alpha }

  xdescribe 'all callbacks' do
    it 'calls CallbackList.all' do
      expect(callback_list_class).to receive(:filter).with(model)
      discover_callbacks_of(model)
    end
  end

  ActiveSupport::Callbacks::CALLBACK_FILTER_TYPES.each do |kind|
    ActiveRecordDiscover::CALLBACK_NAMES.each do |name|
      next unless ActiveRecord::Callbacks::CALLBACKS.include?("#{kind}_#{name}".to_sym)

      context "when name #{name}" do
        it 'calls CallbackList.filter' do
          expect(callback_list_class).to receive(:filter).with(model, kind: nil, name: name).and_call_original
          public_send("discover_#{name}_callbacks_of", model)
        end

        describe "of kind #{kind}" do
          it 'calls CallbackList.filter' do
            expect(callback_list_class).to receive(:filter).with(model, name: name, kind: kind).and_call_original
            public_send("discover_#{kind}_#{name}_callbacks_of", model)
          end
        end
      end

      context "when kind #{kind}" do
        it 'calls CallbackList.filter' do
          expect(callback_list_class).to receive(:filter).with(model, kind: kind, name: nil).and_call_original
          public_send("discover_#{kind}_callbacks_of", model)
        end
      end
    end
  end

  xdescribe "generic methods" do
    ActiveRecordDiscover::ENTITIES.each do |entity|
      list_class = "ActiveRecordDiscover::#{entity.to_s.singularize.capitalize}List".constantize

      context "when entity #{entity}" do
        it "calls .filter on #{list_class}" do
          expect(list_class).to receive(:filter).with(model)
          public_send("discover_#{entity.to_s.pluralize}_of", model)
        end
      end
    end
  end
end
