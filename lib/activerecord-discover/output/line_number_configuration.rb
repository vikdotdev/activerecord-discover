module ActiveRecordDiscover
  class LineNumberConfiguration
    MIN_PADDING = 3.freeze

    class << self
      attr_accessor :config
    end

    def self.reset
      self.config.size = nil if config
    end

    attr_accessor :size

    def self.from_paths(paths)
      self.config ||= LineNumberConfiguration.new

      config.size ||= paths.map do |path|
        [File.open(path).each_line.count.to_s.size, MIN_PADDING].max
      end.max
    end
  end

  module LineNumberHelper
    def padding_size
      LineNumberConfiguration.config.size
    end

    def padded_line_number_dots
      '.' * padding_size
    end

    def padded_line_number_arrow
      arrow = '->'
      "#{' ' * (padding_size - arrow.size)}#{arrow}"
    end

    def padded_line_number_error
      arrow = 'ERR'
      "#{' ' * (padding_size - arrow.size)}#{arrow}"
    end

    def padded_line_number(n)
      n.to_s.rjust(padding_size)
    end
  end
end
