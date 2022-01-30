class IfCondition < ApplicationRecord
  before_save :symbolic_if, if: :if_cond
  before_save :symbolic_if_multiple, if: %i[if_cond if_cond2]
  def symbolic_if; end
  def if_cond; end
  def if_cond2; end

  before_save :proc_if, if: -> do
    '__proc_if_1__'
  end

  before_save :proc_if_multiple, if: [-> { '__proc_if_2__' }, -> { '__proc_if_3__' }]

  # TODO: investigate failure, method_source fails when it's spread over multiple lines
  before_save :proc_if_multiple2, if: [
    -> do
      '__proc_if_4__'
    end,
    -> do
      '__proc_if_5__'
    end
  ]

  def proc_if; end

  # after_save -> do
  # end, if: -> do
  # end
  #
  # around_save :around_save_as_method
  # def around_save_as_method; end
  #
  # around_save -> do
  #   yield
  # end
  #
  # after_save :after_save_as_method
  # def after_save_as_method; end
  #
  # after_save -> do
  #   yield
  # end
end
