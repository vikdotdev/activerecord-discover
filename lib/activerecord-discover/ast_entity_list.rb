module ActiveRecordDiscover
  class ASTEntityList
    def self.find(*args)
      instance = self.new(*args)
      instance.run

      instance
    end

    include Enumerable

    attr_reader :model

    def initialize(model)
      @model = model
      @entities = []
    end

    # move to some helper or even method in printer
    def not_found_message
      "No #{self.class.to_s.split('::').last.to_s.delete_prefix('AST').delete_suffix('List')} found"
    end

    def each(&block)
      @entities.each(&block)
      self
    end

    def empty?
      !any?
    end
  end
end
