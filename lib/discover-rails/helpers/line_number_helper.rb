module DiscoverRails
  module LineHelper
    include HighlightHelper

    DEFAULT_UNINDENT = 2

    def unindent_lines_for(ast)
      first_line = ast.loc.expression.source_buffer.source_line(ast.loc.first_line)
      content_indent = first_line.scan(/\s+/)&.first&.size || DEFAULT_UNINDENT

      ast.loc.expression.source.each_line.each_with_index.map do |line, index|
        index.zero? ? line : line.delete_prefix(' ' * content_indent)
      end.join
    end

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

    def padded_line_number(number)
      number.to_s.rjust(padding_size)
    end

    private

    def padding_size
      LineNumberConfiguration.config.size
    end
  end
end
