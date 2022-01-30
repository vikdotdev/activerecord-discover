module ActiveRecordDiscover
  class Callback
    attr_reader :callback, :model, :filter

    def initialize(callback, model)
      @callback = callback
      @model = model
      @filter = callback.instance_variable_get(:@filter)
    end

    def dump
      # ... get all semi-internal data in hash
      callback
    end

    def print
      # use data to pretty print the callbacks and source locations
      # maybe use colors?

      puts
      puts "#{attrs[:kind]}_#{attrs[:name]} :#{attrs[:filter]}"
      puts
      puts "#{path}:#{line}"
      # puts remove_padding(instance_method.source)
      puts model.instance_method(attrs[:key]).source
      puts
    end

    def method?
      filter.is_a?(Symbol)
    end

    def proc?
      filter.is_a?(Proc)
    end

    def method_line
      source_location.second
    end

    def method_path
      source_location.first
    end

    # move ifs to a module
    # tested?
    def ifs
      attrs[:if]
    end

    # tested?
    def symbolic_ifs
      ifs.select { |value| value.is_a?(Symbol) }
    end

    # tested?
    def proc_ifs
      ifs.select { |value| value.is_a?(Proc) }
    end

    def if_source(symbol_or_proc)
      # show source location
    end

    def unlesses
      attrs[:unless]
    end

    # tested?
    def symbolic_unlesses
      unlesses.select { |value| value.is_a?(Symbol) }
    end

    # tested?
    def proc_unlesses
      unlesses.select { |value| value.is_a?(Proc) }
    end

    def unless_source(symbol_or_proc)
      case symbol_or_proc
      when Symbol
        # ... fetch a instance method off a model and call .source on it
      when Proc
        symbol_or_proc.source
      end
      # show source location
    end

    # move on to a module?
    def on
      # on: ...
    end

    # tested
    def name
      attrs[:name]
    end

    # tested
    def kind
      attrs[:kind]
    end

    private

    # TODO: improve output for a callback object
    def attrs
      @attrs ||= callback.instance_variables.inject({}) do |memo, name|
        memo.merge!(
          name.to_s.delete('@').to_sym => callback.instance_variable_get(name)
        )
        memo
      end
    end

    def source_location
      # based on type
      model.instance_method(attrs[:key]).source_location
    end
  end
end
