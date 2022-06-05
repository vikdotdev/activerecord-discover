class ManualCallbackInModelMethodInConcern < ActiveRecord::Base
  include ConcernManualMethodNoCallback

  before_validation :foo
  before_validation :bar
end
