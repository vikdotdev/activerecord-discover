require 'rails_helper'

RSpec.describe ASTValidationList do
  subject { described_class.find(template.name.constantize) }

  describe "when empty" do
    let(:template) { model_setup :empty }

    it "finds no validations in model" do
      assert_empty subject
    end

    describe "with concerns included" do
      let(:concern_template) { concern_setup :empty }
      let(:template) { model_setup :empty, includes: concern_template }

      it "finds no validations in empty model with empty concern" do
        assert_empty subject
      end
    end

    describe 'when only things resembling validations are present' do
      pending
    end
  end

  describe "when with validates" do
    describe "when no options" do
      let(:template) do
        model_setup :validates_method, options: { presence: true }
      end

      it "finds validation" do
        refute_empty subject

        subject.each do |validation|
          assert_predicate validation, :validates_pattern?
          assert_validation validation, template
          assert_empty validation.methods
          assert_empty validation.condition_methods
        end
      end
    end

    describe "when with options" do
      describe "single condition with single method" do
        %i[if unless].each do |c|
          it "finds validation with condition #{c} and single method" do
            template = model_setup :validates_method, options: { presence: true, c => :a }
            subject = ASTValidationList.find(template.name.constantize)

            refute_empty subject
            subject.each do |validation|
              assert_predicate validation, :validates_pattern?
              assert_validation validation, template
              assert_empty validation.methods
              assert_includes_template_condition_methods validation, template
            end
          end
        end
      end
    end

    describe "single condition with multiple methods" do
      %i[if unless].each do |c|
        it "finds validation with condition :#{c} and single method" do
          template = model_setup :validates_method, options: { presence: true, c => %i[a b c] }
          subject = ASTValidationList.find(template.name.constantize)

          refute_empty subject
          subject.each do |validation|
            assert_predicate validation, :validates_pattern?
            assert_validation validation, template
            assert_empty validation.methods
            assert_includes_template_condition_methods validation, template
          end
        end
      end
    end

    describe "multiple conditions with multiple methods" do
      %i[if unless].permutation.each do |(c1, c2)|
        %i[alpha beta].permutation do |(m1, m2)|
          it "finds validation with multiple conditions and multiple methods" do
            template = model_setup :validates_method, options: { presence: true, c1 => m1, c2 => m2 }
            subject = ASTValidationList.find(template.name.constantize)

            refute_empty subject
            subject.each do |validation|
              assert_predicate validation, :validates_pattern?
              assert_validation validation, template
              assert_empty validation.methods
              assert_includes_template_condition_methods validation, template
            end
          end
        end
      end
    end
  end

  describe "when with validate" do
    describe "when with a method" do
      describe "when no options" do
        let(:template) { model_setup :validate_method, methods: :a }

        it "finds validation" do
          refute_empty subject

          subject.each do |validation|
            assert_predicate validation, :validate_pattern?
            assert_validation validation, template
            assert_includes_template_methods validation, template
            assert_empty validation.condition_methods
          end
        end
      end

      describe 'when with options' do
        describe 'single condition with single method' do
          %i[if unless].each do |c|
            it "finds validation with condition #{c} and single method" do
              template = model_setup :validate_method, methods: :a, options: { c => :b }
              subject = ASTValidationList.find(template.name.constantize)

              refute_empty subject
              subject.each do |validation|
                assert_predicate validation, :validate_pattern?
                assert_validation validation, template
                assert_includes_template_methods validation, template
                assert_includes_template_condition_methods validation, template
              end
            end
          end
        end

        describe 'single condition with multiple methods' do
          %i[if unless].each do |c|
            it "finds validation with condition #{c} and single method" do
              template = model_setup :validate_method, methods: :a, options: { c => %i[b c] }
              subject = ASTValidationList.find(template.name.constantize)

              refute_empty subject
              subject.each do |validation|
                assert_predicate validation, :validate_pattern?
                assert_validation validation, template
                assert_includes_template_methods validation, template
                assert_includes_template_condition_methods validation, template
              end
            end
          end
        end

        describe 'multiple conditions with multiple methods' do
          %i[if unless].permutation.each do |(c1, c2)|
            %i[beta charlie].permutation do |(m1, m2)|
              it 'finds validation with multiple conditions and multiple methods' do
                template = model_setup :validate_method, methods: :a, options: { c1 => m1, c2 => m2 }
                subject = ASTValidationList.find(template.name.constantize)

                refute_empty subject

                subject.each do |validation|
                  assert_predicate validation, :validate_pattern?
                  assert_validation validation, template
                  assert_includes_template_methods validation, template
                  assert_includes_template_condition_methods validation, template
                end
              end
            end
          end
        end
      end
    end

    describe "when with multiple methods" do
      let(:template) { model_setup :validate_method, methods: %i[a b] }

      it "finds validation" do
        refute_empty subject

        subject.each do |validation|
          assert_predicate validation, :validate_pattern?
          assert_validation validation, template
          assert_includes_template_methods validation, template
          assert_empty validation.condition_methods
        end
      end
    end

    describe "when with a proc" do
      describe "when no options" do
        let(:template) { model_setup :validate_proc }

        it "finds validation" do
          refute_empty subject

          subject.each do |validation|
            assert_predicate validation, :validate_pattern?
            assert_validation validation, template
            assert_empty validation.methods
            assert_empty validation.condition_methods
          end
        end
      end

      describe "when with options" do
        %i[if unless].each do |c|
          it "finds validation with condition #{c}" do
            template = model_setup :validate_proc, options: { c => :a }
            subject = ASTValidationList.find(template.name.constantize)

            refute_empty subject
            subject.each do |validation|
              assert_predicate validation, :validate_pattern?
              assert_validation validation, template
              assert_empty validation.methods
              assert_includes_template_condition_methods validation, template
            end
          end
        end
      end
    end

    describe 'when with a method and a proc' do
      describe "when no options" do
        let(:template) { model_setup :validate_method_proc, methods: :a }

        it "finds validation" do
          refute_empty subject

          subject.each do |validation|
            assert_predicate validation, :validate_pattern?
            assert_validation validation, template
            assert_includes_template_methods validation, template
            assert_empty validation.condition_methods
          end
        end
      end

      describe "when with options" do
        %i[if unless].each do |c|
          it "finds validation with condition #{c}" do
            template = model_setup :validate_method_proc, methods: :a, options: { c => :b }
            subject = ASTValidationList.find(template.name.constantize)

            refute_empty subject

            subject.each do |validation|
              assert_predicate validation, :validate_pattern?
              assert_validation validation, template
              assert_includes_template_methods validation, template
              assert_includes_template_condition_methods validation, template
            end
          end
        end
      end
    end

    describe "with concerns included" do
      describe 'when methods are in the model' do
        subject { described_class.find(model_template.name.constantize) }

        describe 'and validation is in a concern' do
          let(:concern_template) do
            concern_setup :validate_method, methods: :a, skip_methods: true
          end
          let(:model_template) do
            model_setup :validate_method, methods: :a, skip_validation: true, includes: concern_template
          end

          it 'finds callback' do
            refute_empty subject

            subject.each do |validation|
              assert_predicate validation, :validate_pattern?
              assert_validation validation, concern_template
              assert_includes_template_methods validation, model_template
              assert_empty validation.condition_methods
            end
          end
        end

        describe "when outside included block" do
          pending
        end
      end

      describe 'when method is in the concern' do
        subject { described_class.find(model_template.name.constantize) }

        describe 'and validation is in the model' do
          let(:concern_template) { concern_setup :validate_method, methods: :a, skip_validation: true }
          let(:model_template) do
            model_setup :validate_method, methods: :a, skip_methods: true, includes: concern_template
          end

          it "finds callback" do
            refute_empty subject

            subject.each do |validation|
              assert_predicate validation, :validate_pattern?
              assert_validation validation, model_template
              assert_includes_template_methods validation, concern_template
              assert_empty validation.condition_methods
            end
          end
        end

        describe 'when validation and method are in the same concern' do
          subject { described_class.find(model_template.name.constantize) }

          let(:concern_template) { concern_setup :validate_method, methods: :a }
          let(:model_template) { model_setup :empty, includes: concern_template }

          it "finds callback" do
            refute_empty subject

            subject.each do |validation|
              assert_predicate validation, :validate_pattern?
              assert_validation validation, concern_template
              assert_includes_template_methods validation, concern_template
              assert_empty validation.condition_methods
            end
          end
        end

        describe "and validation is in another included concern" do
          subject { described_class.find(model_template.name.constantize) }

          let(:concern_template_1) { concern_setup :validate_method, methods: :a, skip_methods: true }
          let(:concern_template_2) { concern_setup :validate_method, methods: :a, skip_validation: true }
          let(:model_template) { model_setup :empty, includes: [concern_template_1, concern_template_2] }

          it "finds callback" do
            refute_empty subject

            subject.each do |validation|
              assert_predicate validation, :validate_pattern?
              assert_validation validation, concern_template_1
              assert_includes_template_methods validation, concern_template_2
              assert_empty validation.condition_methods
            end
          end
        end

        describe "when outside included block" do
          pending
        end
      end
    end

    describe "with single-table inheritance" do
      subject { described_class.find(child_template.name.constantize) }

      describe "when parent has a method, child has a validation" do
        let(:parent_template) { model_setup :validate_method, methods: :a, skip_validation: true }
        let(:child_template) do
          model_setup :validate_method, methods: :a, skip_methods: true, parent: parent_template
        end

        it "finds_callback" do
          refute_empty subject

          subject.each do |validation|
            assert_predicate validation, :validate_pattern?
            assert_validation validation, child_template
            assert_includes_template_methods validation, parent_template
            assert_empty validation.condition_methods
          end
        end
      end
    end
  end

  describe "when with validates_each" do
    describe "when no options" do
      let(:template) { model_setup :validates_each }

      it "finds validation" do
        refute_empty subject

        subject.each do |validation|
          assert_predicate validation, :validates_each_pattern?
          assert_validation validation, template
          assert_empty validation.methods
          assert_empty validation.condition_methods
        end
      end
    end

    describe "when with options" do
      %i[if unless].each do |c|
        it "finds validation" do
          template = model_setup :validates_each, options: { c => :a }
          subject = ASTValidationList.find(template.name.constantize)

          refute_empty subject
          subject.each do |validation|
            assert_predicate validation, :validates_each_pattern?
            assert_validation validation, template
            assert_empty validation.methods
            assert_includes_template_condition_methods validation, template
          end
        end
      end
    end
  end

  describe "when with validates_with" do
    describe "when no options" do
      let(:template) { model_setup :validates_with }

      it "finds validation" do
        refute_empty subject

        subject.each do |validation|
          assert_predicate validation, :validates_with_pattern?
          assert_validation validation, template
          assert_empty validation.methods
          assert_empty validation.condition_methods
        end
      end
    end

    describe "when with options" do
      %i[if unless].each do |c|
        it "finds validation" do
          template = model_setup :validates_with, options: { c => :a }
          subject = ASTValidationList.find(template.name.constantize)

          refute_empty subject
          subject.each do |validation|
            assert_predicate validation, :validates_with_pattern?
            assert_validation validation, template
            assert_empty validation.methods
            assert_includes_template_condition_methods validation, template
          end
        end
      end
    end
  end
end
