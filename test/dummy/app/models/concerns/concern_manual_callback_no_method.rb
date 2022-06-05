module ConcernManualCallbackNoMethod
  extend ActiveSupport::Concern

  included do
    before_validation :foo
    before_validation :bar
  end
end
