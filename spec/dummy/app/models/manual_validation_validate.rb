class ManualValidationValidate < ActiveRecord::Base
  # TODO used for testing non-reachable/non-existant methods
  # validate :baz

  validate :foo
  validate :foo, :bar
  validate :foo, ->{}

  validate :foo do
  end

  validate do
  end

  validate -> do
  end

  validate -> do
  end, :foo

  validate :foo, if: :bar

  def foo
  end

  def bar
  end
end
