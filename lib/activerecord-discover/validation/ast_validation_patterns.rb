module ActiveRecordDiscover
  module ASTValidationPatterns
    PATTERN_VALIDATE = <<-PATTERN.freeze
      ({ (block (send nil { validate }))
         (send nil { validate } ({ block sym } _)) })
    PATTERN
    PATTERN_VALIDATES = <<-PATTERN.freeze
      (send nil {
        validates validates! validates_absence_of validates_acceptance_of
        validates_associated validates_confirmation_of validates_exclusion_of
        validates_format_of validates_inclusion_of validates_length_of
        validates_numericality_of validates_presence_of
        validates_size_of validates_uniqueness_of })
    PATTERN
    PATTERN_VALIDATES_EACH = '(block (send nil { validates_each }))'.freeze
    PATTERN_VALIDATES_WITH = '(send nil { validates_with })'.freeze
    PATTERNS = [
      PATTERN_VALIDATE,
      PATTERN_VALIDATES,
      PATTERN_VALIDATES_EACH,
      PATTERN_VALIDATES_WITH
    ].freeze

    def validate_pattern?
      pattern == PATTERN_VALIDATE
    end

    def validates_pattern?
      pattern == PATTERN_VALIDATES
    end

    def validates_each_pattern?
      pattern == PATTERN_VALIDATES_EACH
    end

    def validates_with_pattern?
      pattern == PATTERN_VALIDATES_WITH
    end

    private

    def pattern
      @pattern ||= PATTERNS.find { |pattern| Fast.match?(pattern, ast) }
    end
  end
end
