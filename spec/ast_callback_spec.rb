require 'rails_helper'

RSpec.describe ASTCallback do
  def src(string)
    "before_validation #{string}"
  end

  def ast(string)
    described_class.new(src(string).to_ast, dummy_model)
  end

  describe 'when method' do
    describe 'when without options' do
      it 'matches when without options' do
        assert_ast ast(':a'), src(':a')
      end

      it 'matches when with multiple methods' do
        assert_ast ast(':a, :b'), src(':a, :b')
      end
    end

    describe 'matches when with conditional options' do
      it { assert_ast ast(':a, if: :b'), src(':a, if: :b') }
      it { assert_ast ast(':a, unless: :b'), src(':a, unless: :b') }

      context 'when with multiple methods' do
        it 'matches when with single conditional' do
          assert_ast ast(':a, :b, if: :c'), src(':a, :b, if: :c')
          assert_ast ast(':a, :b, unless: :c'), src(':a, :b, unless: :c')
        end
      end

      it 'when with permutation of if and unless' do
        assert_ast ast(':a, if: :b, unless: :c'), src(':a, if: :b, unless: :c')
        assert_ast ast(':a, unless: :b, if: :c'), src(':a, unless: :b, if: :c')
      end

      it 'matches when with both if and unless with multiple conditions' do
        assert_ast ast(':a, unless: %i[b c], if: %i[c d]'),
                   src(':a, unless: %i[b c], if: %i[c d]')
      end
    end

    it 'matches when with non-conditional options' do
      assert_ast ast(':a, allow_blank: true'), src(':a, allow_blank: true')
      assert_ast ast(':a, allow_nil: false'), src(':a, allow_nil: false')
      assert_ast ast(':a, on: :create'), src(':a, on: :create')
      assert_ast ast(':a, prepend: true'), src(':a, prepend: true')
    end
  end

  describe 'when proc' do
    it 'matches when without options with different proc syntax variants' do
      assert_ast ast('->{}'),                src('->{}')
      assert_ast ast('->() {}'),             src('->() {}')
      assert_ast ast('->(param) {}'),        src('->(param) {}')
      assert_ast ast("-> do\n  end"),        src("-> do\n  end")
      assert_ast ast("do\n  end"),           src("do\n  end")
      assert_ast ast("->(param) do\n  end"), src("->(param) do\n  end")
    end

    it 'matches when with multiple procs' do
      assert_ast ast('->{}, ->{}'),          src('->{}, ->{}')
      assert_ast ast("->{}, -> do\n end"),   src("->{}, -> do\n end")
    end

    describe 'when with arrow syntax variant' do
      it 'matches when with conditional options' do
        assert_ast ast('->{}, if: :a'), src('->{}, if: :a')
        assert_ast ast('->{}, unless: :a'), src('->{}, unless: :a')
      end

      it 'matches when with permutation of if and unless' do
        assert_ast ast('->{}, if: :b, unless: :c'), src('->{}, if: :b, unless: :c')
        assert_ast ast('->{}, unless: :b, if: :c'), src('->{}, unless: :b, if: :c')
      end

      it 'matches when with non-conditional options' do
        assert_ast ast('->{}, allow_blank: true'), src('->{}, allow_blank: true')
        assert_ast ast('->{}, allow_nil: false'), src('->{}, allow_nil: false')
        assert_ast ast('->{}, on: :create'), src('->{}, on: :create')
        assert_ast ast('->{}, prepend: true'), src('->{}, prepend: true')
      end
    end

    describe 'when with "do" syntax variant' do
      describe 'when with arrow' do
        it 'matches when with non-conditional options' do
          assert_ast ast("-> do\n end, allow_blank: true"), src("-> do\n end, allow_blank: true")
          assert_ast ast("-> do\n end, allow_nil: false"), src("-> do\n end, allow_nil: false")
          assert_ast ast("-> do\n end, on: :create"), src("-> do\n end, on: :create")
          assert_ast ast("-> do\n end, prepend: true"), src("-> do\n end, prepend: true")
        end

        it 'matches when with permutation of if and unless' do
          assert_ast ast("-> do\n end, if: :b, unless: :c"), src("-> do\n end, if: :b, unless: :c")
          assert_ast ast("-> do\n end, unless: :b, if: :c"), src("-> do\n end, unless: :b, if: :c")
        end
      end

      describe 'when without arrow' do
        it 'matches when without options' do
          assert_ast ast("do\n end"), src("do\n end")
        end
      end
    end
  end

  describe 'when with both method and a proc' do
    it 'matches without options' do
      assert_ast ast(':a, ->{}'),                src(':a, ->{}')
      assert_ast ast('->{}, :b'),                src('->{}, :b')
      assert_ast ast(':a, ->() {}'),             src(':a, ->() {}')
      assert_ast ast('->() {}, :b'),             src('->() {}, :b')
      assert_ast ast(':a, ->(param) {}'),        src(':a, ->(param) {}')
      assert_ast ast('->(param) {}, :b'),        src('->(param) {}, :b')
      assert_ast ast(":a, -> do\n  end"),        src(":a, -> do\n  end")
      assert_ast ast("-> do\n  end, :b"),        src("-> do\n  end, :b")
      assert_ast ast(":a do\n  end"),            src(":a do\n  end")
      assert_ast ast(":a, :b do\n  end"),        src(":a, :b do\n  end")
      assert_ast ast(":a, ->(param) do\n  end"), src(":a, ->(param) do\n  end")
      assert_ast ast("->(param) do\n  end, :b"), src("->(param) do\n  end, :b")
    end
  end
end
