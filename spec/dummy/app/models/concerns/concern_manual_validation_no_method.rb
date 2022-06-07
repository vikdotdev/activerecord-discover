module ConcernManualValidationNoMethod
  extend ActiveSupport::Concern

  included do
    validate :foo
  end
end
