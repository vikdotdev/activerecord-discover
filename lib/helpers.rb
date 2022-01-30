module ActiveRecordDiscover
  module Helpers
    def extract_callbacks_from_chain(chain)
      chain.instance_variable_get(:@chain)
    end
  end
end
