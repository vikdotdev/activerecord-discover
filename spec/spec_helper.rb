Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = "random"
  config.filter_run_when_matching :focus
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = 'spec/examples.txt'
end

RSpec::Matchers.define :match_callback_ast do
  match { |actual| actual.match? }
end

RSpec::Matchers.define :match_method_callback_ast do
  match { |actual| actual.method? }
end

RSpec::Matchers.define :match_proc_callback_ast do
  match { |actual| actual.proc? }
end

RSpec::Matchers.define :ast_callback do
  match do |actual|
    actual.is_a?(ActiveRecordDiscover::ASTCallback)
  end
end
RSpec::Matchers.alias_matcher :an_ast_callback, :ast_callback

RSpec::Matchers.define :path_asts_pair do
  match do |actual|
    path, asts = actual

    File.exist?(path) && asts.all? { |ast| ast.is_a?(ActiveRecordDiscover::ASTCallback) }
  end
end

RSpec::Matchers.define :asts_matching do |expected|
  match do |actual|
    _, asts = actual

    asts.all? { |ast| ast.is_a?(Fast::Node) }
  end
end

RSpec::Matchers.define :callback_of_kind do |expected|
  match do |actual|
    _, asts = actual

    asts.all? do |ast|
      ast_callback(ast) && ast.kind.ends_with?(expected.to_s)
    end
  end
end

RSpec::Matchers.define :callback_of_name do |expected|
  match do |actual|
    _, ast_callbacks = actual

    ast_callbacks.all? do |ast|
      an_ast_callback(ast) && ast.name.ends_with?(expected.to_s)
    end
  end
end
