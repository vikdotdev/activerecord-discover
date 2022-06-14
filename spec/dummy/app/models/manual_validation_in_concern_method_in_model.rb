class ManualValidationInConcernMethodInModel < ActiveRecord::Base
  include ConcernManualValidationNoMethod

  def foo
  end
end
