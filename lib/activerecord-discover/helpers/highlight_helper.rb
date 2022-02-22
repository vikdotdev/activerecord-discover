module ActiveRecordDiscover
  module HighlightHelper
    include ConfigurationHelper

    def highlight_format_source(source)
      theme = Rouge::Themes::ThankfulEyes.new
      formatter = Rouge::Formatters::TerminalTruecolor.new(theme)
      lexer = Rouge::Lexers::Ruby.new
      formatter.format(lexer.lex(source))
    end

    def gray_colored(string)
      colors_enabled? ? string.light_black : string
    end
  end
end
