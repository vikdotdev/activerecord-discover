class ManualValidationStiChild < ManualValidationStiParent
  validate :bar, :baz

  def baz
  end
end
