module ActiveRecordDiscover
  module EntityPatterns
    def send_pattern
      raise NotImplementedError
    end

    def block_pattern
      <<-PATTERN.squish
        { (block #{send_pattern} ...) }
      PATTERN
    end

    # def with_options_pattern
    #   <<-PATTERN.squish
    #     { (block (send nil? :with_options ...) ... #{yield}) }
    #   PATTERN
    # end
    #
    # def with_options_pattern?
    #   false
    # end
  end
end
