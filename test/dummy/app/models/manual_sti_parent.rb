class ManualStiParent < ActiveRecord::Base
  def parent_callback_method_for_child
  end

  def parent_callback_method_for_parent
    1 + 1
  end

  before_validation :parent_callback_method_for_parent
end
