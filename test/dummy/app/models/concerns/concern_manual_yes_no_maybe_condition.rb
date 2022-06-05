module ConcernManualYesNoMaybeCondition
  extend ActiveSupport::Concern

  included do
    def yes?(); true end

    def no?() false end

    def maybe?
      [true, false].sample
    end
  end
end
