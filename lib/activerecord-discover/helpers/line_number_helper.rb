module ActiveRecordDiscover
  module LineNumberHelper
    include HighlightHelper

    def line_number_source(source, ast)
      return source if ast.nil?

      first, last = line_numbers_for(ast)
      current = first

      source.each_line.map do |line|
        padded_current = "| #{padded_line_number(current)} |"
        padded_current = gray_colored(padded_current)
        with_line_number = "#{padded_current} #{line}"
        current += 1 unless current == last

        with_line_number
      end.compact.join
    end

    def line_numbers_for(ast)
      [ast.loc.first_line, ast.loc.last_line]
    end

    def padding_size
      LineNumberConfiguration.config.size
    end

    def padded_line_number_dots
      '.' * padding_size
    end

    def padded_line_number_arrow
      symbol = '->'
      "#{' ' * (padding_size - symbol.size)}#{symbol}"
    end

    def padded_line_number_error
      symbol = 'ERR'
      "#{' ' * (padding_size - symbol.size)}#{symbol}"
    end

    def padded_line_number(n)
      n.to_s.rjust(padding_size)
    end
  end
end
