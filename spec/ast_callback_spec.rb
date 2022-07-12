require 'rails_helper'

RSpec.describe ASTCallback do
  def build_ast(string)
    described_class.new("before_validation #{string}".to_ast, dummy_model)
  end

  describe 'when method' do
    describe 'when without options' do
      it 'matches when without options' do
        assert_predicate build_ast(':a'), :match?
      end

      it 'matches when with multiple methods' do
        assert_predicate build_ast(':a, :b'), :match?
      end
    end

    describe 'matches when with conditional options' do
      it { assert_predicate build_ast(':a, if: :b'), :match? }
      it { assert_predicate build_ast(':a, unless: :b'), :match? }

      it 'when with permutation of if and unless' do
        assert_predicate build_ast(':a, if: :b, unless: :c'), :match?
        assert_predicate build_ast(':a, unless: :b, if: :c'), :match?
      end

      it 'matches when with both if and unless with multiple conditions' do
        assert_predicate build_ast(':a, if: %i[b c], unless: %i[c d]'),
                         :match?
        assert_predicate build_ast(':a, unless: %i[b c], if: %i[c d]'),
                         :match?
      end
    end

    it 'matches when with non-conditional options' do
      assert_predicate build_ast(':a, allow_blank: true'), :match?
      assert_predicate build_ast(':a, allow_nil: false'), :match?
      assert_predicate build_ast(':a, on: :create'), :match?
      assert_predicate build_ast(':a, prepend: true'), :match?
    end
  end

  describe 'when proc' do
    it 'matches when without options with different proc syntax variants' do
      assert_predicate build_ast('->{}'),                :match?
      assert_predicate build_ast('->() {}'),             :match?
      assert_predicate build_ast('->(param) {}'),        :match?
      assert_predicate build_ast("-> do\n  end"),        :match?
      assert_predicate build_ast("do\n  end"),           :match?
      assert_predicate build_ast("->(param) do\n  end"), :match?
    end

    it 'matches when with multiple procs' do
      assert_predicate build_ast('->{}, ->{}'),          :match?
      assert_predicate build_ast("->{}, -> do\n end"),   :match?
    end

    describe 'when with arrow syntax variant' do
      it 'matches when with conditional options' do
        assert_predicate build_ast('->{}, if: :a'), :match?
        assert_predicate build_ast('->{}, unless: :a'), :match?
      end

      it 'matches when with permutation of if and unless' do
        assert_predicate build_ast('->{}, if: :b, unless: :c'), :match?
        assert_predicate build_ast('->{}, unless: :b, if: :c'), :match?
      end

      it 'matches when with non-conditional options' do
        assert_predicate build_ast('->{}, allow_blank: true'), :match?
        assert_predicate build_ast('->{}, allow_nil: false'), :match?
        assert_predicate build_ast('->{}, on: :create'), :match?
        assert_predicate build_ast('->{}, prepend: true'), :match?
      end
    end

    describe 'when with "do" syntax variant' do
      describe 'when with arrow' do
        it 'matches when with non-conditional options' do
          assert_predicate build_ast("-> do\n end, allow_blank: true"), :match?
          assert_predicate build_ast("-> do\n end, allow_nil: false"), :match?
          assert_predicate build_ast("-> do\n end, on: :create"), :match?
          assert_predicate build_ast("-> do\n end, prepend: true"), :match?
        end

        it 'matches when with permutation of if and unless' do
          assert_predicate build_ast("-> do\n end, if: :b, unless: :c"), :match?
          assert_predicate build_ast("-> do\n end, unless: :b, if: :c"), :match?
        end
      end

      describe 'when without arrow' do
        it 'matches when without options' do
          assert_predicate build_ast("do\n end"), :match?
        end
      end
    end
  end

  describe 'when with both method and a proc' do
    it 'matches without options' do
      assert_predicate build_ast(':a, ->{}'),                :match?
      assert_predicate build_ast('->{}, :b'),                :match?
      assert_predicate build_ast(':a, ->() {}'),             :match?
      assert_predicate build_ast('->() {}, :b'),             :match?
      assert_predicate build_ast(':a, ->(param) {}'),        :match?
      assert_predicate build_ast('->(param) {}, :b'),        :match?
      assert_predicate build_ast(":a, -> do\n  end"),        :match?
      assert_predicate build_ast("-> do\n  end, :b"),        :match?
      assert_predicate build_ast(":a do\n  end"),            :match?
      assert_predicate build_ast(":a, :b do\n  end"),        :match?
      assert_predicate build_ast(":a, ->(param) do\n  end"), :match?
      assert_predicate build_ast("->(param) do\n  end, :b"), :match?
    end
  end
end
