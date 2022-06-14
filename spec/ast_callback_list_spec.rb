require 'rails_helper'

RSpec.describe ASTCallbackList do
  describe "when empty" do
    subject { ASTCallbackList.find(template.name.constantize) }

    describe 'without concerns' do
      let(:template) { model_setup :empty }

      it 'finds no callbacks in model' do
        assert_empty subject
      end
    end

    describe 'with concerns included' do
      let(:concern_template) { concern_setup :empty }
      let(:template) { model_setup :empty, includes: concern_template }

      it 'finds no callbacks in empty model with empty concern' do
        assert_empty subject
      end
    end

    describe "when no actual callbacks exist, only things resembling callback" do
      let(:template) do
        model_setup :callback_not_real, callback: :before_custom, methods: :alpha
      end

      it "finds no callbacks" do
        assert_kind_of ASTCallbackList, subject
        assert_empty subject
      end
    end
  end

  describe "kind and name permutations" do
    PermutationHelper.callback_pairs.each do |kind, name, combined|
      it "finds a method callback with kind #{kind} and name #{name}" do
        template = model_setup :callback_method, callback: combined, methods: :alpha
        subject = ASTCallbackList.find(template.name.constantize, kind: kind, name: name)

        assert_kind_of ASTCallbackList, subject
        refute_empty subject
        assert_equal kind, subject.kind
        assert_equal name, subject.name

        subject.each do |callback|
          assert_callback callback, template
          assert_predicate callback, :method_pattern?
          assert_equal kind.to_s, callback.kind
          assert_equal name.to_s, callback.name
          assert_includes_template_methods callback, template
          assert_empty callback.condition_methods
        end
      end

      it "finds a proc callback with kind #{kind} and name #{name}" do
        template = model_setup :callback_proc, callback: combined, methods: :alpha
        subject = ASTCallbackList.find(template.name.constantize, kind: kind, name: name)

        assert_kind_of ASTCallbackList, subject
        refute_empty subject
        assert_equal kind, subject.kind
        assert_equal name, subject.name

        subject.each do |callback|
          assert_callback callback, template
          assert_predicate callback, :proc_pattern?
          assert_equal kind.to_s, callback.kind
          assert_equal name.to_s, callback.name
          assert_empty callback.methods
          assert_empty callback.condition_methods
        end
      end
    end
  end

  describe 'conditions' do
    subject { ASTCallbackList.find(template.name.constantize) }

    describe 'single condition with single method' do
      %i[if unless].each do |condition|
        let(:template) do
          model_setup :callback_method, options: { condition => :beta }, methods: :alpha
        end

        it "finds callback with condition #{condition} and single method" do
          refute_empty subject

          subject.each do |callback|
            assert_callback callback, template
            assert_predicate callback, :method_pattern?
            assert_includes_template_methods callback, template
            assert_includes_template_condition_methods callback, template
          end
        end
      end
    end

    describe 'single condition with multiple methods' do
      %i[if unless].each do |condition|
        let(:template) do
          model_setup :callback_method, methods: :alpha,
            options: { condition => %i[beta charlie] }
        end

        it "finds callback with condition :#{condition} and multiple methods" do
          refute_empty subject

          subject.each do |callback|
            assert_callback callback, template
            assert_predicate callback, :method_pattern?
            assert_includes_template_methods callback, template
            assert_includes_template_condition_methods callback, template
          end
        end
      end
    end

    describe 'multiple conditions with multiple methods' do
      %i[if unless].permutation.each do |(condition_1, condition_2)|
        %i[beta charlie].permutation do |(option_method_1, option_method_2)|
          let(:template) do
            model_setup :callback_method, methods: :alpha,
              options: { condition_1 => option_method_1, condition_2 => option_method_2 }
          end

          it 'finds callback with multiple conditions and multiple methods' do
            refute_empty subject

            subject.each do |callback|
              assert_callback callback, template
              assert_predicate callback, :method_pattern?
              assert_includes_template_methods callback, template
              assert_includes_template_condition_methods callback, template
            end
          end
        end
      end
    end
  end

  describe "with concerns included" do
    subject { ASTCallbackList.find(model_template.name.constantize) }

    describe 'when methods are in the model' do
      describe 'and callback is in a concern' do
        let(:concern_template) do
          concern_setup :callback_method, methods: :alpha, skip_methods: true
        end
        let(:model_template) do
          model_setup :callback_method, methods: :alpha,
            includes: concern_template, skip_callback: true
        end

        it "finds callback" do
          refute_empty subject

          subject.each do |callback|
            assert_predicate callback, :method_pattern?
            assert_callback callback, concern_template
            assert_includes_template_methods callback, model_template
            assert_empty callback.condition_methods
          end
        end
      end

      describe "when outside included block" do
        it "finds callback with that method" do
          skip "Not implemented"
        end
      end
    end

    describe 'when method is in the concern' do
      describe 'and callback is in the model' do
        let(:concern_template) do
          concern_setup :callback_method, methods: :alpha, skip_callback: true
        end
        let(:model_template) do
          model_setup :callback_method, methods: :alpha,
            skip_methods: true, includes: concern_template
        end

        it "finds callback" do
          refute_empty subject

          subject.each do |callback|
            assert_predicate callback, :method_pattern?
            assert_callback callback, model_template
            assert_includes_template_methods callback, concern_template
            assert_empty callback.condition_methods
          end
        end
      end

      describe 'when callback and method are in the same concern' do
        let(:concern_template) { concern_setup :callback_method, methods: :alpha }
        let(:model_template) { model_setup :empty, includes: concern_template }

        it "finds callback" do
          refute_empty subject

          subject.each do |callback|
            assert_predicate callback, :method_pattern?
            assert_callback callback, concern_template
            assert_includes_template_methods callback, concern_template
            assert_empty callback.condition_methods
          end
        end
      end

      describe "and callback is in another included concern" do
        let(:concern_template_methods) do
          concern_setup :callback_method, methods: :alpha, skip_callback: true
        end
        let(:concern_template_callback) do
          concern_setup :callback_method, methods: :alpha, skip_methods: true
        end
        let(:model_template) do
          model_setup :empty, includes: [concern_template_callback, concern_template_methods]
        end

        it "finds_callback" do
          refute_empty subject

          subject.each do |callback|
            assert_predicate callback, :method_pattern?
            assert_callback callback, concern_template_callback
            assert_includes_template_methods callback, concern_template_methods
            assert_empty callback.condition_methods
          end
        end
      end

      describe "when outside included block" do
        it "finds callback with that method" do
          skip "Not implemented"
        end
      end
    end
  end

  describe "with single-table inheritance" do
    subject { ASTCallbackList.find(child_template.name.constantize) }

    describe "when parent has a method, child has a callback" do
      let(:parent_template) { model_setup :callback_method, methods: :alpha, skip_callback: true }
      let(:child_template) do
        model_setup :callback_method, methods: :alpha, skip_methods: true, parent: parent_template
      end

      it "finds callback" do
        refute_empty subject

        subject.each do |callback|
          assert_callback callback, child_template
          assert_predicate callback, :method_pattern?
          assert_includes_template_methods callback, parent_template
          assert_empty callback.condition_methods
        end
      end
    end
  end
end
