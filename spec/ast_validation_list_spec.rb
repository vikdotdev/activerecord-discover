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

        subject.each do |group|
          assert_predicate group.validation, :validates_pattern?
          assert_validation group.validation, template
          assert_empty group.validation.methods
          assert_empty group.validation.condition_methods
        end
      end
    end

    describe "when with options" do
      describe "single condition with single method" do
        %i[if unless].each do |condition_key|
          let(:template) { model_setup :validates_method, options: { presence: true, condition_key => :alpha } }

          it "finds validation with condition #{condition_key} and single method" do
            refute_empty subject

            subject.each do |group|
              assert_predicate group.validation, :validates_pattern?
              assert_validation group.validation, template
              assert_empty group.validation.methods
              assert_includes_template_condition_methods group.validation, template
            end
          end
        end
      end
    end

    describe "single condition with multiple methods" do
      %i[if unless].each do |condition_key|
        let(:template) do
          model_setup :validates_method, options: { presence: true, condition_key => condition_methods }
        end
        let(:condition_methods) { %i[alpha beta charlie] }

        it "finds validation with condition :#{condition_key} and single method" do
          refute_empty subject

          subject.each do |group|
            assert_predicate group.validation, :validates_pattern?
            assert_validation group.validation, template
            assert_empty group.validation.methods
            assert_includes_template_condition_methods group.validation, template
          end
        end
      end
    end

    describe "multiple conditions with multiple methods" do
      %i[if unless].permutation.each do |(condition_1, condition_2)|
        %i[alpha beta].permutation do |(condition_method_1, condition_method_2)|
          let(:template) do
            model_setup :validates_method,
              options: { presence: true, condition_1 => condition_method_1, condition_2 => condition_method_2 }
          end

          it "finds validation with multiple conditions and multiple methods" do
            refute_empty subject

            subject.each do |group|
              assert_predicate group.validation, :validates_pattern?
              assert_validation group.validation, template
              assert_empty group.validation.methods
              assert_includes_template_condition_methods group.validation, template
            end
          end
        end
      end
    end
  end

  describe "when with validate" do
    describe "when with a method" do
      describe "when no options" do
        let(:template) { model_setup :validate_method, methods: :alpha }

        it "finds validation" do
          refute_empty subject

          subject.each do |group|
            assert_predicate group.validation, :validate_pattern?
            assert_validation group.validation, template
            assert_includes_template_methods group.validation, template
            assert_empty group.validation.condition_methods
          end
        end
      end

      describe "when with options" do
        describe "single condition with single method" do
          %i[if unless].each do |condition_key|
            let(:template) { model_setup :validate_method, methods: :alpha, options: { condition_key => :beta } }

            it "finds validation with condition #{condition_key} and single method" do
              refute_empty subject

              subject.each do |group|
                assert_predicate group.validation, :validate_pattern?
                assert_validation group.validation, template
                assert_includes_template_methods group.validation, template
                assert_includes_template_condition_methods group.validation, template
              end
            end
          end
        end

        describe "single condition with multiple methods" do
          %i[if unless].each do |condition_key|
            let(:template) do
              model_setup :validate_method, methods: :alpha, options: { condition_key => %i[beta charlie] }
            end

            it "finds validation with condition #{condition_key} and single method" do
              refute_empty subject

              subject.each do |group|
                assert_predicate group.validation, :validate_pattern?
                assert_validation group.validation, template
                assert_includes_template_methods group.validation, template
                assert_includes_template_condition_methods group.validation, template
              end
            end
          end
        end

        describe "multiple conditions with multiple methods" do
          %i[if unless].permutation.each do |(condition_key_1, condition_key_2)|
            %i[beta charlie].permutation do |(method_1, method_2)|
              let(:template) do
                model_setup :validate_method, methods: :alpha,
                  options: { condition_key_1 => method_1, condition_key_2 => method_2 }
              end

              it "finds validation with multiple conditions and multiple methods" do
                refute_empty subject

                subject.each do |group|
                  assert_predicate group.validation, :validate_pattern?
                  assert_validation group.validation, template
                  assert_includes_template_methods group.validation, template
                  assert_includes_template_condition_methods group.validation, template
                end
              end
            end
          end
        end
      end
    end

    describe "when with multiple methods" do
      let(:template) { model_setup :validate_method, methods: [:alpha, :beta] }

      it "finds validation" do
        refute_empty subject

        subject.each do |group|
          assert_predicate group.validation, :validate_pattern?
          assert_validation group.validation, template
          assert_includes_template_methods group.validation, template
          assert_empty group.validation.condition_methods
        end
      end
    end

    describe "when with a proc" do
      describe "when no options" do
        let(:template) { model_setup :validate_proc }

        it "finds validation" do
          refute_empty subject

          subject.each do |group|
            assert_predicate group.validation, :validate_pattern?
            assert_validation group.validation, template
            assert_empty group.validation.methods
            assert_empty group.validation.condition_methods
          end
        end
      end

      describe "when with options" do
        %i[if unless].each do |condition_key|
          let(:template) do
            model_setup :validate_proc, options: { condition_key => :alpha }
          end

          it "finds validation with condition #{condition_key}" do
            refute_empty subject

            subject.each do |group|
              assert_predicate group.validation, :validate_pattern?
              assert_validation group.validation, template
              assert_empty group.validation.methods
              assert_includes_template_condition_methods group.validation, template
            end
          end
        end
      end
    end

    describe 'when with a method and a proc' do
      describe "when no options" do
        let(:template) { model_setup :validate_method_proc, methods: :alpha }

        it "finds validation" do
          refute_empty subject

          subject.each do |group|
            assert_predicate group.validation, :validate_pattern?
            assert_validation group.validation, template
            assert_includes_template_methods group.validation, template
            assert_empty group.validation.condition_methods
          end
        end
      end

      describe "when with options" do
        %i[if unless].each do |condition_key|
          let(:template) do
            model_setup :validate_method_proc, methods: :alpha, options: { condition_key => :beta }
          end

          it "finds validation with condition #{condition_key}" do
            refute_empty subject

            subject.each do |group|
              assert_predicate group.validation, :validate_pattern?
              assert_validation group.validation, template
              assert_includes_template_methods group.validation, template
              assert_includes_template_condition_methods group.validation, template
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
            concern_setup :validate_method, methods: :alpha, skip_methods: true
          end
          let(:model_template) do
            model_setup :validate_method, methods: :alpha, skip_validation: true, includes: concern_template
          end

          it 'finds callback' do
            refute_empty subject

            subject.each do |group|
              assert_predicate group.validation, :validate_pattern?
              assert_validation group.validation, concern_template
              assert_includes_template_methods group.validation, model_template
              assert_empty group.validation.condition_methods
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
          let(:concern_template) { concern_setup :validate_method, methods: :alpha, skip_validation: true }
          let(:model_template) do
            model_setup :validate_method, methods: :alpha, skip_methods: true, includes: concern_template
          end

          it "finds callback" do
            refute_empty subject

            subject.each do |group|
              assert_predicate group.validation, :validate_pattern?
              assert_validation group.validation, model_template
              assert_includes_template_methods group.validation, concern_template
              assert_empty group.validation.condition_methods
            end
          end
        end

        describe 'when validation and method are in the same concern' do
          subject { described_class.find(model_template.name.constantize) }

          let(:concern_template) { concern_setup :validate_method, methods: :alpha }
          let(:model_template) { model_setup :empty, includes: concern_template }

          it "finds callback" do
            refute_empty subject

            subject.each do |group|
              assert_predicate group.validation, :validate_pattern?
              assert_validation group.validation, concern_template
              assert_includes_template_methods group.validation, concern_template
              assert_empty group.validation.condition_methods
            end
          end
        end

        describe "and validation is in another included concern" do
          subject { described_class.find(model_template.name.constantize) }

          let(:concern_template_1) { concern_setup :validate_method, methods: :alpha, skip_methods: true }
          let(:concern_template_2) { concern_setup :validate_method, methods: :alpha, skip_validation: true }
          let(:model_template) { model_setup :empty, includes: [concern_template_1, concern_template_2] }

          it "finds callback" do
            refute_empty subject

            subject.each do |group|
              assert_predicate group.validation, :validate_pattern?
              assert_validation group.validation, concern_template_1
              assert_includes_template_methods group.validation, concern_template_2
              assert_empty group.validation.condition_methods
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
        let(:parent_template) { model_setup :validate_method, methods: :alpha, skip_validation: true }
        let(:child_template) do
          model_setup :validate_method, methods: :alpha, skip_methods: true, parent: parent_template
        end

        it "finds_callback" do
          refute_empty subject

          subject.each do |group|
            assert_predicate group.validation, :validate_pattern?
            assert_validation group.validation, child_template
            assert_includes_template_methods group.validation, parent_template
            assert_empty group.validation.condition_methods
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

        subject.each do |group|
          assert_predicate group.validation, :validates_each_pattern?
          assert_validation group.validation, template
          assert_empty group.validation.methods
          assert_empty group.validation.condition_methods
        end
      end
    end

    describe "when with options" do
      %i[if unless].each do |condition_key|
        let(:template) { model_setup :validates_each, options: { condition_key => :alpha } }

        it "finds validation" do
          refute_empty subject

          subject.each do |group|
            assert_predicate group.validation, :validates_each_pattern?
            assert_validation group.validation, template
            assert_empty group.validation.methods
            assert_includes_template_condition_methods group.validation, template
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

        subject.each do |group|
          assert_predicate group.validation, :validates_with_pattern?
          assert_validation group.validation, template
          assert_empty group.validation.methods
          assert_empty group.validation.condition_methods
        end
      end
    end

    describe "when with options" do
      %i[if unless].each do |condition_key|
        let(:template) { model_setup :validates_with, options: { condition_key => :alpha } }

        it "finds validation" do
          refute_empty subject

          subject.each do |group|
            assert_predicate group.validation, :validates_with_pattern?
            assert_validation group.validation, template
            assert_empty group.validation.methods
            assert_includes_template_condition_methods group.validation, template
          end
        end
      end
    end
  end
end
