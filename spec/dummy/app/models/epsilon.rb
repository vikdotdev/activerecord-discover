# Is intended for testing the STI, Epsilon is child model.
class Epsilon < Delta
  def child_callback_method_for_child
  end

  before_validation :parent_callback_method_for_child
  before_validation :child_callback_method_for_child
end
