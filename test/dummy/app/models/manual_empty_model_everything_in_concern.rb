class ManualEverythingInConcern < ActiveRecord::Base
  include ConcernManualMethodCallback
  include ConcernManualProcCallback
end
