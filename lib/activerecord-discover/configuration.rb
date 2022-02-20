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
end
