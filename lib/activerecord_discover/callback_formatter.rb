module ActiveRecordDiscover
  class CallbackFormatter
    def self.from_pairs(ast_callback_list)
      new(ast_callback_list).format
    end

    attr_reader :ast_callback_list

    def initialize(ast_callback_list)
      @ast_callback_list = ast_callback_list
    end

    def format
      ast_callback_list.map do |pair|
        path, ast_callbacks = pair

        # TODO: perfect use case for decorator here
        ast_callbacks.map do |ast_callback|
          {
            path: truncate_from_root(path),
            source: {
              plain: unparse(ast_callback),
              highlighted: syntax_highlight(unparse(ast_callback)),
              with_numbers: unparse_with_line_numbers(ast_callback),
              highlighted_with_numbers: syntax_highlight(unparse_with_line_numbers(ast_callback))
            }
          }
        end
      end.flatten
    end

    private

    def unparse(ast_callback)
      Unparser.unparse(ast_callback.ast)
    end

    def unparse_with_line_numbers(ast_callback)
      first, last, padding = line_numbers_for(ast_callback)
      current = first
      unparse(ast_callback).each_line.map do |line|
        padded_current = current.to_s.rjust(padding)
        with_line_number = "| #{padded_current} | #{line}"
        current += 1 unless current == last

        with_line_number
      end.join
    end

    def line_numbers_for(ast_callback)
      loc = ast_callback.ast.loc
      [loc.first_line, loc.last_line, loc.last_line.to_s.size]
    end

    def truncate_from_root(path)
      Pathname.new(path).relative_path_from(Rails.root)
    end

    def syntax_highlight(source)
      # TODO: add check whether terminal is truecolor? fallback to 256 colors
      formatter = Rouge::Formatters::TerminalTruecolor.new
      lexer = Rouge::Lexers::Ruby.new
      formatter.format(lexer.lex(source))
    end
  end
end
