class ManualValidationStiParent < ActiveRecord::Base

  validate :foo

  def foo
  end

  def bar
  end
end
