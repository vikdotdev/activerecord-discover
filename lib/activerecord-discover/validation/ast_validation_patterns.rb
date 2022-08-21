module ActiveRecordDiscover
  module ASTValidationPatterns
    # TODO inline?
    VALIDATES_METHODS = %w[
      validates validates! validates_absence_of validates_acceptance_of
      validates_associated validates_confirmation_of validates_exclusion_of
      validates_format_of validates_inclusion_of validates_length_of
      validates_numericality_of validates_presence_of validates_size_of
      validates_uniqueness_of
    ].freeze

    def validates_pattern
      "(send nil? { :#{VALIDATES_METHODS.join(' :')} } ...)"
    end

    def validate_pattern
      '(send nil? { :validate } ...)'
    end

    def validates_each_pattern
      '(send nil? { :validates_each } ...)'
    end

    def validates_with_pattern
      '(send nil? { :validates_with } ...)'
    end

    def send_pattern
      <<-PATTERN.squish
        { #{validates_pattern} #{validate_pattern}
          #{validates_each_pattern} #{validates_with_pattern} }
      PATTERN
    end
  end
end
