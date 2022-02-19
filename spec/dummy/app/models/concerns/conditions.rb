module Conditions
  extend ActiveSupport::Concern

  included do
    def yes?
      true
    end

    def no?
      false
    end
  end
end
