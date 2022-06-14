class ManualValidationDifferentConcerns < ActiveRecord::Base
  include ConcernManualValidationMethod, ConcernManualValidationNoMethod
end
