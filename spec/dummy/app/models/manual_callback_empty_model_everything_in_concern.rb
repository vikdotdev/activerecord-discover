class ManualCallbackEverythingInConcern < ActiveRecord::Base
  include ConcernManualMethodCallback
  include ConcernManualProcCallback
end
