module ActiveRecordDiscover
  class WithLineNumbersFormatter < BaseFormatter
    attr_reader :padding

    def initialize(ast_callback, formatter, path)
      super(ast_callback, formatter)
      @padding = File.open(path).lines.count.to_s.size
    end

    def format
      with_line_numbers(component.format)
    end

    private

    def with_line_numbers(source)
      first, last = line_numbers_for(ast_callback)
      current = first
      source.each_line.map do |line|
        padded_current = "| #{current.to_s.rjust(padding)} |".light_black
        with_line_number = "#{padded_current} #{line}"
        current += 1 unless current == last

        with_line_number
      end.join
    end

    def line_numbers_for(ast_callback)
      loc = ast_callback.ast.loc
      [loc.first_line, loc.last_line]
    end
  end
end
