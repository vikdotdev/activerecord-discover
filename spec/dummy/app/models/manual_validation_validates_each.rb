class ManualValidationValidatesEach < ActiveRecord::Base
  validates_each :name, :surname, if: [:foo, ->{}], unless: :bar do |record, attr, value|
    record.errors.add(attr, 'must start with upper case') if value =~ /\A[[:lower:]]/
  end

  def foo
  end

  def bar
  end

  # Present here to make sure column :name is not interpreted as method
  def name
  end
end
