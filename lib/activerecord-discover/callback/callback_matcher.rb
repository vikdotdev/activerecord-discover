module ActiveRecordDiscover
  class CallbackMatcher < EntityMatcher
    include ASTCallbackPatterns

    def match?
      send_pattern?
    end
  end
end
