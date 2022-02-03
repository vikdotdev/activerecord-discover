module ActiveRecordDiscover
  class CallbackFormatter
    attr_reader :ast

    def self.from_array(callback_list)
      callback_list.map do |pair|
        path, ast_callbacks = pair

        puts
        ast_callbacks.map do |ast_callback|
          puts "#{path}:#{ast_callback.ast.loc.first_line}"
          puts Unparser.unparse(ast_callback.ast)
          puts
        end
        puts
      end
    end
  end
end
