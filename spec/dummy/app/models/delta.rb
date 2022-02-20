# Is intended for testing the STI, Delta is parent model.
# See Epsilon - child model
class Delta < ApplicationRecord
  def parent_callback_method_for_child
  end

  def parent_callback_method_for_parent
  end

  before_validation :parent_callback_method_for_parent
end
