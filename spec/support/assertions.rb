module Minitest::Assertions

  # Borrowed from which library?
  def assert_same_elements(a1, a2, msg = nil)
    [:select, :inject, :size].each do |m|
      [a1, a2].each {|a| assert_respond_to(a, m, "Are you sure that #{a.inspect} is an array?  It doesn't respond to #{m}.") }
    end

    assert a1h = a1.inject({}) { |h,e| h[e] ||= a1.select { |i| i == e }.size; h }
    assert a2h = a2.inject({}) { |h,e| h[e] ||= a2.select { |i| i == e }.size; h }

    assert_equal(a1h, a2h, msg)
  end

  def assert_callback(callback, template)
    assert_kind_of ASTCallback, callback
    assert_entity(callback, template, entity: :callback)
  end

  def assert_validation(validation, template)
    assert_kind_of ASTValidation, validation
    assert_entity(validation, template, entity: :validation)
  end

  def assert_entity(entity_obj, template, entity:)
    refute_nil template.yield_content(entity), "Expected template #{entity} not to be nil"
    refute_nil entity_obj.ast, "Expected #{entity} ast not to be nil"
    assert_equal entity_obj.ast, template.yield_content(entity).to_ast, <<~ERROR
      Expected AST that produces source:

      #{entity_obj.ast.source}

      to be equal to template AST that produces source:
      #{template.yield_content(entity)}
    ERROR
  end

  def assert_includes_template_argument_methods(entity, template)
    refute_empty entity.argument_methods

    actual_method_asts = entity.argument_methods.map(&:ast).compact.map(&:source)
    expected_method_asts = template.argument_methods.map do |method_name|
      template.yield_content("method_#{method_name}".to_sym)&.to_ast
    end.compact.map(&:source)

    refute_empty actual_method_asts
    refute_empty expected_method_asts

    assert_same_elements actual_method_asts, expected_method_asts
  end

  def assert_includes_template_hash_methods(entity, template)
    refute_empty entity.hash_methods

    actual_method_asts = entity.hash_methods.map(&:ast).compact.map(&:source)
    expected_method_asts = template.hash_methods.map do |method_name|
      template.yield_content("condition_method_#{method_name}".to_sym).to_ast
    end.compact.map(&:source)

    refute_empty actual_method_asts
    refute_empty expected_method_asts

    assert_same_elements actual_method_asts, expected_method_asts
  end

  def assert_ast(ast, source_string)
    assert_equal ast.ast.source.squish, source_string.squish
  end
end
