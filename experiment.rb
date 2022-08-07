
require 'bundler/inline'

gemfile do
  gem 'activesupport'
  gem "rubocop-ast"
  gem 'pry-byebug'
end

require 'active_support/all'

class ASTR
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
    if (match = ASTR.pattern(pattern).match(node, *args))
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


METHODS = ":before_validation :before_save".freeze

st1 = <<-CODE.squish
  before_validation :a
CODE

bt1 = <<-CODE.squish
  before_validation :a do
  end
CODE

wo1 = <<-CODE.squish
  with_options :a do
    before_validation :a
  end
CODE

wo2 = <<-CODE.squish
  with_options :a do
    before_validation :a do
    end
  end
CODE

def send_pattern
  <<-PATTERN.squish
    { (send nil? { #{METHODS} } ...) }
  PATTERN
end

alias :sdp :send_pattern

def block_pattern
  <<-PATTERN.squish
    { (block #{send_pattern} ...) }
  PATTERN
end

alias :bkp :block_pattern

def with_options_pattern
  <<-PATTERN.squish
    { (block (send nil? :with_options ...) ... #{yield}) }
  PATTERN
end

alias :wop :with_options_pattern

def match?(pattern, code)
  ast = ASTR.from(code)
  puts ast
  puts
  puts pattern

  ASTR.pattern(pattern).match(ast)
end

puts [
  (match? sdp, st1),
  (match? bkp, bt1),
  (match? wop { sdp }, wo1),
  (match? wop { bkp }, wo2)
].all?
binding.pry

puts
puts 'done'


# TODO conclusion - just search for inner most pattern via rubocop or manually,
# then look for parent conditionally and pick parent if makes sense
# ASTR.search_path(sdp, './experiment-text.rb').last.parent.parent
