module ActiveRecordDiscover
  CALLBACK_NAMES = %i[initialize find touch validation save
                      create update destroy commit rollback].freeze
  ENTITIES = %i[callbacks validations associations].freeze
end
