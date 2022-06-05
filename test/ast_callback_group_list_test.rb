require "test_helper"

module ActiveRecordDiscover
  class ASTCallbackTest < ActiveSupport::TestCase
    describe "kind and name permutations" do
      PermutationHelper.callback_pairs.each do |kind, name, callback|
        it "finds a method callback: #{callback}" do
          template = model_setup :method, callback: callback, method: :example

          actual = ASTCallbackGroupList.filter(template.name.constantize, kind: kind, name: name)

          refute_empty actual
          assert_kind_of ASTCallbackGroupList, actual

          assert_equal kind, actual.kind
          assert_equal name, actual.name

          actual.each do |group|
            assert_kind_of ASTCallbackGroup, group
            assert_predicate  group.callback, :method?
            assert_equal template.yield_content(:callback).to_ast, group.callback.ast
            assert_equal kind.to_s, group.callback.kind
            assert_equal name.to_s, group.callback.name

            assert_equal template.yield_content(:method).to_ast, group.method.ast
          end
        end

        it "finds a proc callback: #{callback}" do
          template = model_setup :proc, callback: callback

          actual = ASTCallbackGroupList.filter(template.name.constantize, kind: kind, name: name)

          refute_empty actual
          assert_kind_of ASTCallbackGroupList, actual

          assert_equal kind, actual.kind
          assert_equal name, actual.name

          actual.each do |group|
            assert_kind_of ASTCallbackGroup, group
            assert_predicate  group.callback, :proc?
            assert_equal template.yield_content(:callback).to_ast, group.callback.ast
            assert_equal kind.to_s, group.callback.kind
            assert_equal name.to_s, group.callback.name
          end
        end
      end
    end

    describe "conditions" do
      describe "single condition with single method" do
        options_method = :condition_example

        %i[if unless].each do |condition|
          it "finds callback with condition :#{condition} and single method" do
            template = model_setup :options_with_method, callback: :before_save,
              method: :example, options: { condition => options_method }, methods: [options_method]

            actual = ASTCallbackGroupList.filter(template.name.constantize)
            refute_empty actual

            actual.each do |group|
              assert_equal template.yield_content(:callback).to_ast, group.callback.ast
              assert_equal template.yield_content(:method).to_ast, group.method.ast

              assert_includes group.condition_methods.map(&:ast),
                template.yield_content("condition_method_#{options_method}".to_sym).to_ast
            end
          end
        end
      end

      describe "single condition with multiple methods" do
        options_methods = %i[alpha beta charlie]

        %i[if unless].each do |condition|
          it "finds callback with condition :#{condition} and multiple methods" do
            template = model_setup :options_with_method,
              callback: :before_validation, method: :example,
              options: { condition => options_methods }, methods: options_methods

            actual = ASTCallbackGroupList.filter(template.name.constantize)
            refute_empty actual

            actual.each do |group|
              assert_equal template.yield_content(:callback).to_ast, group.callback.ast
              assert_equal template.yield_content(:method).to_ast, group.method.ast

              options_methods.each do |method|
                assert_includes group.condition_methods.map(&:ast),
                  template.yield_content("condition_method_#{method}".to_sym).to_ast
              end
            end
          end
        end
      end

      describe "multiple conditions with multiple methods" do
        %i[if unless].permutation.each do |(condition_1, condition_2)|
          %i[alpha beta].permutation do |(option_method_1, option_method_2)|
            it "finds callback with multiple conditions and multiple methods" do
              template = model_setup :options_with_method,
                callback: :before_validation, method: :example,
                options: { condition_1 => option_method_1, condition_2 => option_method_2 },
                methods: [option_method_1, option_method_2]

              actual = ASTCallbackGroupList.filter(template.name.constantize)
              refute_empty actual

              actual.each do |group|
                assert_equal template.yield_content(:callback).to_ast, group.callback.ast
                assert_equal template.yield_content(:method).to_ast, group.method.ast

                actual_options_methods = [option_method_1, option_method_2].map do |method|
                  template.yield_content("condition_method_#{method}".to_sym).to_ast
                end
                expected_options_methods = group.condition_methods.map(&:ast)

                assert_same_elements actual_options_methods, expected_options_methods
              end
            end
          end
        end
      end
    end

    describe "when empty" do
      it "finds no callbacks in model" do
        template = model_setup :empty

        assert_empty ASTCallbackGroupList.filter(template.name.constantize)
      end

      describe "with concerns included" do
        it "finds no callbacks in empty model with empty concern" do
          concern_template = concern_setup :empty
          model_template = model_setup :empty, includes: concern_template

          assert_empty ASTCallbackGroupList.filter(model_template.name.constantize)
        end
      end
    end

    describe "with concerns included" do
      describe 'when methods are in the model' do
        describe 'and callback is in a concern' do
          it "finds callback" do
            concern_template = concern_setup :method, callback: :before_save,
              method: :example, skip_method_definition: true
            model_template = model_setup :method, method: :example, includes: concern_template

            actual = ASTCallbackGroupList.filter(model_template.name.constantize)
            refute_empty actual

            actual.each do |group|
              assert_kind_of ASTCallbackGroup, group
              assert_predicate  group.callback, :method?
              assert_equal concern_template.yield_content(:callback).to_ast, group.callback.ast
              assert_equal model_template.yield_content(:method).to_ast, group.method.ast
            end
          end
        end

        describe "when outside included block" do
          it "finds callback with that method" do
            skip "TODO implement the test"
          end
        end
      end

      describe 'when method is in the concern' do
        describe 'and callback is in the model' do
          it "finds callback" do
            concern_template = concern_setup :method, method: :example
            model_template = model_setup :method, callback: :before_save,
              method: :example, skip_method_definition: true, includes: concern_template

            actual = ASTCallbackGroupList.filter(model_template.name.constantize)
            refute_empty actual

            actual.each do |group|
              assert_kind_of ASTCallbackGroup, group
              assert_predicate  group.callback, :method?
              assert_equal model_template.yield_content(:callback).to_ast, group.callback.ast
              assert_equal concern_template.yield_content(:method).to_ast, group.method.ast
            end
          end
        end

        describe 'when callback and method are in the same concern' do
          it "finds callback" do
            concern_template = concern_setup :method, callback: :before_save, method: :example
            model_template = model_setup :empty, includes: concern_template

            actual = ASTCallbackGroupList.filter(model_template.name.constantize)
            refute_empty actual

            actual.each do |group|
              assert_kind_of ASTCallbackGroup, group
              assert_predicate  group.callback, :method?
              assert_equal concern_template.yield_content(:callback).to_ast, group.callback.ast
              assert_equal concern_template.yield_content(:method).to_ast, group.method.ast
            end
          end
        end

        describe "and callback is in another included concern" do
          it "finds_callback" do
            concern_template_with_method = concern_setup :method, method: :example
            concern_template_with_callback = concern_setup :method, callback: :before_save,
              method: :example, skip_method_definition: true
            model_template = model_setup :empty,
              includes: [concern_template_with_callback, concern_template_with_method]

            actual = ASTCallbackGroupList.filter(model_template.name.constantize)
            refute_empty actual

            actual.each do |group|
              assert_kind_of ASTCallbackGroup, group
              assert_predicate  group.callback, :method?
              assert_equal concern_template_with_callback.yield_content(:callback).to_ast, group.callback.ast
              assert_equal concern_template_with_method.yield_content(:method).to_ast, group.method.ast
            end
          end
        end

        describe "when outside included block" do
          it "finds callback with that method" do
            skip "TODO implement the test"
          end
        end
      end
    end

    describe "with single-table inheritance" do
      describe "when parent has a method, child has a callback" do
        it "finds_callback" do
          parent_template = model_setup :method, method: :example
          child_template = model_setup :method, callback: :before_save,
            method: :example, skip_method_definition: true, inherits_from: parent_template

          actual = ASTCallbackGroupList.filter(child_template.name.constantize)
          refute_empty actual

          actual.each do |group|
            assert_kind_of ASTCallbackGroup, group
            assert_predicate  group.callback, :method?
            assert_equal parent_template.yield_content(:method).to_ast, group.method.ast
            assert_equal child_template.yield_content(:callback).to_ast, group.callback.ast
          end
        end
      end
    end

    describe "when no actual callbacks exist, only things resembling callback" do
      it "finds no callbacks" do
        template = model_setup :not_real_callback, callback: :before_custom, method: :example

        actual = ASTCallbackGroupList.filter(template.name.constantize)

        assert_kind_of ASTCallbackGroupList, actual
        assert_empty actual
      end
    end
  end
end
