class ManualValidationValidates < ActiveRecord::Base
  validates :name, presence: true
  validates :name, presence: true, if: :foo, unless: ->{}
  validates :name, presence: true, if: [:bar, :foo]
  validates :name, presence: true, if: [:foo, :bar, :foo]
  validates :name, presence: true, unless: [:foo, :bar, :foo]
  validates :name, presence: true, if: :foo, unless: :bar
  validates :name, presence: true, if: :foo, unless: [:bar, :foo]
  validates :name, uniqueness: { case_sensitive: true }
  validates :name, uniqueness: true
  validates_presence_of :name
  validates_presence_of :name, if: :foo, unless: [:bar, :foo]
  # TODO add more variants

  def foo
  end

  def bar
  end

  # Present here to make sure column :name does not get interpreted as method
  def name
  end
end
