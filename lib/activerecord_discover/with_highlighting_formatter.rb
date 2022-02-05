module ActiveRecordDiscover
  class WithHighlightingFormatter < BaseFormatter
    def format
      with_syntax_highlight(@component.format)
    end

    private

    def with_syntax_highlight(source)
      theme = Rouge::Themes::ThankfulEyes.new
      formatter = Rouge::Formatters::TerminalTruecolor.new(theme)
      lexer = Rouge::Lexers::Ruby.new
      formatter.format(lexer.lex(source))
    end
  end
end
