module ActiveRecordDiscover
  class << self
    attr_accessor :config
  end

  def self.configure
    self.config ||= Configuration.new
    yield(config) if block_given?
  end

  class Configuration
    attr_accessor :colors, :line_numbers, :show_full_path

    def initialize
      @colors = true
      @line_numbers = true
      @show_full_path = false
    end
  end

  module ConfigurationHelper
    def colors_enabled?
      ActiveRecordDiscover.config.colors
    end

    def line_numbers_enabled?
      ActiveRecordDiscover.config.line_numbers
    end

    def show_full_path?
      ActiveRecordDiscover.config.show_full_path
    end
  end

  class LineNumberConfiguration
    MIN_PADDING = 3

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
end
