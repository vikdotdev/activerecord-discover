class ManualValidationValidate < ActiveRecord::Base
  validate :baz

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
