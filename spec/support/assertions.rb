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
    assert_equal entity_obj.ast, template.yield_content(entity).to_ast
  end

  def assert_includes_template_methods(entity, template)
    refute_empty entity.methods

    actual_method_asts = entity.methods.map(&:ast).compact
    expected_method_asts = template.methods.map do |method_name|
      template.yield_content("method_#{method_name}".to_sym)&.to_ast
    end.compact

    refute_empty actual_method_asts
    refute_empty expected_method_asts

    assert_same_elements actual_method_asts, expected_method_asts
  end

  def assert_includes_template_condition_methods(entity, template)
    refute_empty entity.condition_methods

    actual_method_asts = entity.condition_methods.map(&:ast).compact
    expected_method_asts = template.condition_methods.map do |method_name|
      template.yield_content("condition_method_#{method_name}".to_sym).to_ast
    end.compact

    refute_empty actual_method_asts
    refute_empty expected_method_asts

    assert_same_elements actual_method_asts, expected_method_asts
  end
end
