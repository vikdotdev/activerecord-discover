module ActiveRecordDiscover
  class CallbackPermutator
    def self.all_permutations(&block)
      new(:all).permutate(&block)
    end

    def self.kind_name_permutations(&block)
      new(:kind_name).permutate(&block)
    end

    def initialize(type)
      @type = type
    end

    def permutate(&block)
      send(@type).map { |kind, name| yield(kind, name) }
    end

    private

    def all
      # ...
      []
    end

    def kind_name
      # ...
      []
    end
  end
end
