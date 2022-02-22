# Is intended for testing the output when there are no callbacks present,
# only code that might resemble callbacks.
class Gamma < ApplicationRecord
  include Methods
  include ApplicationHelper

  class << self
    def after_foo(var); end
  end

  after_foo :bar
end
