require 'rails_helper'

RSpec.describe ASTCallback do
  subject { described_class.new(ast, dummy_model) }

  describe 'when method' do
    describe 'when without options' do
      let(:ast) { 'before_validation :example'.to_ast }

      it 'matches when without options' do
        assert_predicate subject, :match?
      end

      describe 'when with multiple methods' do
        let(:ast) { "before_validation :alpha, :beta".to_ast }

        it "matches" do
          skip 'Not implemented'
          assert_predicate subject, :match?
        end
      end
    end

    describe 'when with conditional options' do
      %i[if unless].each do |condition|
        let(:ast) { "before_validation :alpha, #{condition}: :example".to_ast }

        it "matches when with #{condition}" do
          assert_predicate subject, :match?
        end
      end

      describe 'when with permutation of if and unless' do
        %i[if unless].permutation.each do |(condition_1, condition_2)|
          let(:ast) { "before_validation :alpha, #{condition_1}: :beta, #{condition_2}: :charlie".to_ast }

          it "matches when with #{condition_1}, #{condition_2}" do
            assert_predicate subject, :match?
          end
        end
      end

      describe 'when with both if and unless multiple condition methods' do
        %i[if unless].permutation.each do |(condition_1, condition_2)|
          let(:ast) do
            "before_validation :alpha, #{condition_1}: %i[beta charlie], #{condition_2}: %i[charlie delta]".to_ast
          end

          it "matches when with #{condition_1}, #{condition_2}" do
            assert_predicate subject, :match?
          end
        end
      end
    end

    describe 'when with non-conditional options' do
      [
        'allow_blank: true',
        'allow_nil: false',
        'on: :create',
        # TODO
        # 'prepend: true',
      ].each do |syntax_variant|
        let(:ast) { "before_validation :alpha, #{syntax_variant}".to_ast }

        it 'matches' do
          assert_predicate subject, :match?
        end
      end
    end
  end

  describe 'when proc' do
    describe 'with when without options with different proc syntax variants' do
      [
        '->{}',
        '->() {}',
        '->(param) {}',
        <<~CODE,
          -> do
          end
        CODE
        # TODO
        # <<~CODE,
        #   do
        #   end
        # CODE
        <<~CODE,
          ->(param) do
          end
        CODE
      ].each do |syntax_variant|
        let(:ast) { "before_validation #{syntax_variant}".to_ast }

        it "matches when proc syntax variant is #{syntax_variant}" do
          assert_predicate subject, :match?
        end
      end
    end

    describe 'when with arrow syntax variant' do
      describe 'when with conditional options' do
        %i[if unless].each do |condition|
          let(:ast) { "before_validation ->{}, #{condition}: :alpha".to_ast }

          it "matches when with #{condition}" do
            assert_predicate subject, :match?
          end
        end

        describe 'when with permutation of if and unless' do
          %i[if unless].permutation.each do |(condition_1, condition_2)|
            let(:ast) { "before_validation ->{}, #{condition_1}: :alpha, #{condition_2}: :beta".to_ast }

            it "matches when with #{condition_1}, #{condition_2}" do
              assert_predicate subject, :match?
            end
          end
        end
      end

      describe 'when with non-conditional options' do
        [
          'allow_blank: true',
          'allow_nil: false',
          'on: :create',
          # TODO
          # 'prepend: true',
        ].each do |syntax_variant|
          let(:ast) { "before_validation ->{}, #{syntax_variant}".to_ast }

          it 'matches' do
            assert_predicate subject, :match?
          end
        end
      end
    end

    describe 'when without arrow syntax variant' do
      pending
    end
  end
end
