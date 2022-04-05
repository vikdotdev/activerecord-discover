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

RSpec::Matchers.define :ast_callback_metadata do
  match do |actual|
    actual.flatten.present? && actual.all? { |metadata| metadata.is_a?(ActiveRecordDiscover::ASTCallbackMetadata) }
  end
end

RSpec::Matchers.define :ast_callback_metadata_with_callback_of_kind do |expected|
  match do |actual|
    actual.flatten.present? && actual.map { |metadata| metadata.callback }.all? do |ast|
      ast_callback(ast) && ast.kind.ends_with?(expected.to_s)
    end
  end
end

RSpec::Matchers.define :ast_callback_metadata_with_callback_of_name do |expected|
  match do |actual|
    actual.flatten.present? && actual.map { |metadata| metadata.callback }.all? do |ast|
      an_ast_callback(ast) && ast.name.ends_with?(expected.to_s)
    end
  end
end

RSpec::Matchers.define :ast_callback_with_condition_methods do |*expected|
  match do |actual|
    an_ast_callback(actual) &&
      actual.conditions_method_names.uniq.map(&:to_sym).sort == expected.uniq.map(&:to_sym).sort
  end

  failure_message do |actual|
    "Expected #{actual.conditions_method_names.map(&:to_sym)} to equal #{expected}, when callback code is #{code.inspect}"
  end
end
RSpec::Matchers.alias_matcher :be_an_ast_callback_with_condition_methods,
                              :ast_callback_with_condition_methods
