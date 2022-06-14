module ConcernManualProcCallback
  extend ActiveSupport::Concern

  included do
    before_validation -> do
    end

    before_validation ->() { 1 + 1 }
  end
end
