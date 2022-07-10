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

    def each(&block)
      @entities.each(&block)
      self
    end

    def empty?
      !any?
    end
  end
end
