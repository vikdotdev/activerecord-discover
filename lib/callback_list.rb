module ActiveRecordDiscover
  class CallbackList
    extend ActiveRecordDiscover::Helpers

    def self.all(model, kind: nil, name: nil)
      callbacks_chains = model.__callbacks.to_a

      callbacks_chains.map do |callback_chain|
        chain_name, chain = callback_chain
        next if !name.nil? && name != chain_name
        callbacks = extract_callbacks_from_chain(chain)

        callbacks.map do |active_record_callback|
          callback = ActiveRecordDiscover::Callback.new(active_record_callback, model)

          next if !kind.nil? && callback.kind != kind

          callback
        end
      end.flatten.compact
    end
  end
end
