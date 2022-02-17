class WithOption < ApplicationRecord
  def yes?
    true
  end

  def no?
    false
  end

  # Initialize
  after_initialize :after_initialize_as_method, if: :yes?, unless: :no?
  def after_initialize_as_method; end

  after_initialize -> do
  end, if: :yes?, unless: :no?

  # Find
  after_find :after_find_as_method, if: %i[yes? yes?], unless: :no?
  def after_find_as_method; end

  after_find -> do
  end, if: [:yes?, :yes?], unless: :no?

  # Touch
  after_touch :after_touch_as_method, if: %i[yes? yes?], unless: %i[no? no?]
  def after_touch_as_method; end

  after_touch -> do
  end, if: %i[yes? yes?], unless: %i[no? no?]

  # Validation
  before_validation :before_validation_as_method, on: :create
  def before_validation_as_method; end

  before_validation -> do
  end, on: :create

  after_validation :after_validation_as_method, on: %i[create]
  def after_validation_as_method; end

  after_validation -> do
  end, on: %i[create]

  # Save
  before_validation :before_validation_as_method,
    on: %i[create update],
    if: %i[yes? yes?],
    unless: %i[no? no?]

  before_validation :before_validation_as_method,
    on: :destroy,
    unless: %i[no? no?],
    if: %i[yes? yes?]

  def before_save_as_method;
    1 + 1 == 2
  end

  before_validation -> do
  end, on: :destroy, unless: :no?, if: :yes?
end
