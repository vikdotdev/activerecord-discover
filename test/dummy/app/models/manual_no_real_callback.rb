class ManualNoRealCallback < ActiveRecord::Base
  include ConcernManualMethodNoCallback
  include ApplicationHelper

  class << self
    def after_foo(var); end
  end

  after_foo :bar
end
