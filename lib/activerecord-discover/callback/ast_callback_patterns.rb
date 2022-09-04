module ActiveRecordDiscover
  module ASTCallbackPatterns
    # TODO add aliases
    def send_pattern
      "(send nil? { :#{ActiveRecord::Callbacks::CALLBACKS.join(' :')} } ...)"
    end
  end
end
