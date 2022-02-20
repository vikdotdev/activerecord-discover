# Is intended for testing the output when methods are on one concern, and
# callbacks are on the other concern
class Thetum < ApplicationRecord
  include Methods
  include CallbacksWithoutMethods
end
