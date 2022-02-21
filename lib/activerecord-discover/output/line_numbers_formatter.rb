module ActiveRecordDiscover
  class LineNumbersFormatter
    include ConfigurationHelper
    include LineNumberHelper

    attr_reader :source, :ast

    def initialize(source, ast)
      @source = source
      @ast = ast
    end

    def format
      return source if ast.nil?

      first, last = line_numbers_for(ast)
      current = first

      source.each_line.map do |line|
        padded_current = "| #{padded_line_number(current)} |"
        padded_current = padded_current.light_black if colors_enabled?
        with_line_number = "#{padded_current} #{line}"
        current += 1 unless current == last

        with_line_number
      end.compact.join
    end

    def line_numbers_for(ast)
      [ast.loc.first_line, ast.loc.last_line]
    end
  end
end
