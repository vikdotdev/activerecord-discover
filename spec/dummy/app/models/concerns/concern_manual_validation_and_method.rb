module ConcernManualValidationAndMethod
  extend ActiveSupport::Concern

  included do
    validate :baz

    def baz
    end
  end
end
