class ManualCallbackMethodProcVariants < ActiveRecord::Base
  after_initialize ->{}

  after_initialize ->{}, if: :alpha

  after_initialize -> do
  end

  # TODO test when method is not found, now crashes
  after_initialize -> do
  end, if: :alpha

  after_initialize :alpha, -> do
  end

  # TODO test when multiple methods, now only first one is displayed
  after_initialize :alpha, :beta, -> do
  end

  after_initialize do
  end

  after_initialize :alpha do
  end

  after_initialize :alpha, :beta do
  end

  def alpha
  end

  def beta
  end
end
