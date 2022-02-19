# Is intended for testing the output when methods are defined in the concern
class Zetum < ApplicationRecord
  include Methods

  before_validation :foo
  before_validation :bar
end
