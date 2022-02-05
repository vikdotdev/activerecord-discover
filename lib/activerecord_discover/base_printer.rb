module ActiveRecordDiscover
  class BasePrinter
    def self.print(formatted_callbacks)
      new(formatted_callbacks).print
    end

    attr_reader :formatted_callbacks

    def initialize(formatted_callbacks)
      @formatted_callbacks = formatted_callbacks
    end

    def print
      # TODO: make it an option to print path for every file, or alternatively, stack them
      current_path = nil
      puts
      formatted_callbacks.each do |callback|
        puts callback[:path] unless current_path == callback[:path]
        current_path = callback[:path]

        puts callback[:source]
        puts
      end

      nil
    end
  end
end
