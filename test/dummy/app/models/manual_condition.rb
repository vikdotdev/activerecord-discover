class ManualCondition < ActiveRecord::Base
  include ConcernManualYesNoMaybeCondition

  def validation_callback
  end

  before_validation :validation_callback, if:     %i[maybe? no? yes?]

  before_validation :validation_callback, unless: %i[no? yes? maybe?]

  before_validation :validation_callback, if:     %i[maybe? no? yes?],
                                          on:     %i[create update destroy]

  before_validation :validation_callback, unless: %i[no? yes? maybe?],
                                          on:     :destroy

  before_validation :validation_callback, if:     %i[maybe? no? yes?],
                                          unless: %i[yes? no? maybe?],
                                          on:     %i[create update destroy]

  before_validation :validation_callback, unless: %i[yes? maybe? no?],
                                          if:     %i[yes? no? maybe?],
                                          on:     %i[update create destroy]

  before_validation :validation_callback, if:     %i[maybe? yes? no?],
                                          on:     %i[update destroy create],
                                          unless: %i[no? maybe? yes?]

  before_validation :validation_callback, on:     %i[destroy update create],
                                          if:     %i[no? maybe? yes?],
                                          unless: %i[maybe? yes? no?]

  before_validation :validation_callback, if:     :no?,
                                          unless: %i[yes? maybe?]

  before_validation :validation_callback, if:     %i[no? maybe?],
                                          unless: :yes?
end
