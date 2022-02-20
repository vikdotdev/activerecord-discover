# Is intended for testing the output when methods are on the model, but
# callbacks are on the concern
class Etum < ApplicationRecord
  include CallbacksWithoutMethods

  def foo
    :foo
  end

  def bar
    :bar
  end
end
