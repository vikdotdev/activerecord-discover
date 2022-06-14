class ManualValidationInModelMethodInConcern < ActiveRecord::Base
  include ConcernManualValidationMethod

  validate :foo
end
