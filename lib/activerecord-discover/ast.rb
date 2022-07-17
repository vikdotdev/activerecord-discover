module ActiveRecordDiscover
  class AST
    def self.from(string)
      RuboCop::AST::ProcessedSource.new(string, RUBY_VERSION.to_f).ast
    end

    def self.from_path(path)
      RuboCop::AST::ProcessedSource.from_file(path, RUBY_VERSION.to_f).ast
      # how to pass named arguments and constants?
      # similar to https://docs.rubocop.org/rubocop-ast/node_pattern.html
    end

    def self.search_path(pattern, path)
      ast = from_path(path)

      search pattern, ast
    end

    def self.pattern(string)
      RuboCop::AST::NodePattern.new(string)
      # how to pass named arguments and constants?
      # similar to https://docs.rubocop.org/rubocop-ast/node_pattern.html
    end

    def self.search(pattern, node, *args)
      if (match = AST.pattern(pattern).match(node, *args))
        yield node, match if block_given?
        # match != true ? [node, match] : [node]
        [node]
      else
        node.each_child_node
            .flat_map { |child| search(pattern, child, *args) }
            .compact
            .uniq
      end
    end
  end
end
