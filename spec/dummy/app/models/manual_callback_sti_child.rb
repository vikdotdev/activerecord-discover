class ManualCallbackStiChild < ManualCallbackStiParent
  def child_callback_method_for_child
  end

  before_validation :parent_callback_method_for_child
  before_validation :child_callback_method_for_child
end
