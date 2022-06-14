class FooValidator < ActiveModel::Validator
  def validate(record)
    if record.name != :foo
      record.errors.add :base, 'is not foo'
    end
  end
end

class BarValidator < ActiveModel::Validator
  def validate(record)
    if record.name != :bar
      record.errors.add :base, 'is not bar'
    end
  end
end

class ManualValidationValidatesWith < ActiveRecord::Base
  validates_with FooValidator
  validates_with FooValidator, if: :foo
  validates_with FooValidator, if: :foo, unless: :bar
  validates_with FooValidator, BarValidator

  def foo
  end

  def bar
  end
end
