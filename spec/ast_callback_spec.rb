require 'rails_helper'

# TODO cleanup examples
RSpec.describe ASTCallback do
  describe 'when method' do
    it 'matches when without options' do
      ast = 'before_save :example'.to_ast

      assert_predicate ASTCallback.new(ast), :match?
    end


    describe 'when with conditional options' do
      %i[if unless].each do |condition|
        it "matches when with #{condition}" do
          ast = "before_save :example, #{condition}: :example".to_ast

          assert_predicate ASTCallback.new(ast), :match?
        end
      end

      describe 'when with permutation of if and unless' do
        %i[if unless].permutation.each do |(condition_1, condition_2)|
          it "matches when with #{condition_1}, #{condition_2}" do
            ast = "before_save :ex, #{condition_1}: :ex, #{condition_2}: :ex".to_ast

            assert_predicate ASTCallback.new(ast), :match?
          end
        end
      end
    end

    describe 'when with non-conditional options' do
      it 'matches' do
        ast = "before_save :example, hello: :example".to_ast

        assert_predicate ASTCallback.new(ast), :match?
      end
    end
  end

  describe 'when proc' do
    describe 'with when without options with different proc syntax variants' do
      [
        "->{}",
        "->() {}",
        "->(param) {}",
        <<~EOS,
          -> do
          end
        EOS
        <<~EOS,
          ->(param) do
          end
        EOS
      ].each do |proc_syntax_variant|
        it "matches when proc syntax variant is #{proc_syntax_variant}" do
          ast = "before_save #{proc_syntax_variant}".to_ast

          assert_predicate ASTCallback.new(ast), :match?
        end
      end
    end

    describe 'when with conditional options' do
      %i[if unless].each do |condition|
        it "matches when with #{condition}" do
          ast = "before_save ->{}, #{condition}: :example".to_ast

          assert_predicate ASTCallback.new(ast), :match?
        end
      end

      describe 'when with permutation of if and unless' do
        %i[if unless].permutation.each do |(condition_1, condition_2)|
          it "matches when with #{condition_1}, #{condition_2}" do
            ast = "before_save ->{}, #{condition_1}: :ex, #{condition_2}: :ex".to_ast

            assert_predicate ASTCallback.new(ast), :match?
          end
        end
      end
    end

    describe 'when with non-conditional options' do
      it 'matches' do
        ast = "before_save ->{}, hello: :example".to_ast

        assert_predicate ASTCallback.new(ast), :match?
      end
    end
  end
end
