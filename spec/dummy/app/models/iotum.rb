# Is intended for testing the output when methods and callbacks are both in a
# single concern. Also tests proc callbacks from concern
class Iotum < ApplicationRecord
  include CallbacksWithMethods
  include CallbacksOnlyProcs
end
