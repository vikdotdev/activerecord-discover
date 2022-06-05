module ConcernManualMethodCallback
  extend ActiveSupport::Concern

  included do
    before_validation :foo
    before_validation :bar

    def foo
      :foo
    end
  end

  def bar
    :bar
  end
end
