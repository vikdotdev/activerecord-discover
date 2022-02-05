module ActiveRecordDiscover
  class BaseFormatter
    def self.from_pairs(ast_callback_list)
      ast_callback_list.map do |pair|
        path, ast_callbacks = pair

        ast_callbacks.map do |ast_callback|
          formatter = new(ast_callback)
          formatter = ActiveRecordDiscover::WithHighlightingFormatter.new(ast_callback, formatter)
          formatter = ActiveRecordDiscover::WithLineNumbersFormatter.new(ast_callback, formatter, path)

          { path: Pathname.new(path).relative_path_from(Rails.root), source: formatter.format }
        end
      end.flatten
    end

    attr_reader :component, :ast_callback

    def initialize(ast_callback, component = nil)
      @component = component
      @ast_callback = ast_callback
    end

    def format
      Unparser.unparse(ast_callback.ast)
    end
  end
end
