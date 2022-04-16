module ConcernManualMethodNoCallback
  extend ActiveSupport::Concern

  included do
    def foo
      :foo
    end

    def bar
      :bar
    end
  end
end
