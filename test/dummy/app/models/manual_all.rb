# All callback types
class ManualAll < ActiveRecord::Base
  # Initialize
  after_initialize :after_initialize_as_method
  def after_initialize_as_method; end

  after_initialize -> do
    1 + 1 == 2
  end

  # Find
  after_find :after_find_as_method

  def after_find_as_method; end

  after_find -> do
  end

  # Touch
  after_touch :after_touch_as_method

  def after_touch_as_method
    1 + 1 == 2
  end

  after_touch -> do
  end

  # Validation
  before_validation :before_validation_as_method
  def before_validation_as_method; end

  before_validation -> do
  end

  after_validation :after_validation_as_method
  def after_validation_as_method; end

  # Save
  before_save :before_save_as_method
  def before_save_as_method
    1 + 1 == 2
  end

  before_save -> do
  end

  around_save :around_save_as_method
  def around_save_as_method; end

  around_save -> do
    yield
  end

  after_save :after_save_as_method
  def after_save_as_method; end

  after_save -> do
  end

  # Create
  before_create :before_create_as_method
  def before_create_as_method; end

  before_create -> do
  end

  around_create :around_create_as_method
  def around_create_as_method; end

  around_create -> do
    yield
  end

  after_create :after_create_as_method
  def after_create_as_method; end

  after_create -> do
  end

  # Update
  before_update :before_update_as_method
  def before_update_as_method; end

  before_update -> do
  end

  around_update :around_update_as_method
  def around_update_as_method; end

  around_update -> do
    yield
  end

  after_update :after_update_as_method
  def after_update_as_method; end

  after_update -> do
    yield
  end

  # Destroy
  before_destroy :before_destroy_as_method
  def before_destroy_as_method; end

  before_destroy -> do
  end

  around_destroy :around_destroy_as_method
  def around_destroy_as_method; end

  around_destroy -> do
    yield
  end

  after_destroy :after_destroy_as_method
  def after_destroy_as_method; end

  after_destroy -> do
    yield
  end

  # Commit
  after_commit :after_commit_as_method
  def after_commit_as_method; end

  after_commit -> do
  end

  after_rollback :after_rollback_as_method

  def after_rollback_as_method;
    1 + 2
  end

  after_rollback -> do
  end
end
