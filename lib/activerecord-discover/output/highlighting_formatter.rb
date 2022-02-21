module ActiveRecordDiscover
  class HighlightingFormatter
    attr_reader :source

    def initialize(source)
      @source = source
    end

    def format
      theme = Rouge::Themes::ThankfulEyes.new
      formatter = Rouge::Formatters::TerminalTruecolor.new(theme)
      lexer = Rouge::Lexers::Ruby.new
      formatter.format(lexer.lex(source))
    end
  end
end
