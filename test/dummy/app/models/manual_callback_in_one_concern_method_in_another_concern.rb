class ManualCallbackInOneConcernMethodInAnotherConcern < ActiveRecord::Base
  include ConcernManualMethodNoCallback
  include ConcernManualCallbackNoMethod
end