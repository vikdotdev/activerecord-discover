class ManualMethodInModelCallbackInConcern < ActiveRecord::Base
  include ConcernManualCallbackNoMethod

  def foo
    :foo
  end

  def bar
    :bar
  end
end
