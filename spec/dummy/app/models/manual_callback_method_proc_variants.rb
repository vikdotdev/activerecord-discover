class ManualCallbackMethodProcVariants < ActiveRecord::Base
  # TODO what about -> {} ?
  after_initialize -> do
  end

  # TODO next 3 do not work, won't be matched
  after_initialize do
  end

  after_initialize :alpha, -> do
  end

  after_initialize :beta do
  end
end
