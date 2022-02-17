require 'rails_helper'

RSpec.describe ActiveRecordDiscover::ASTCallback do
  subject { ActiveRecordDiscover::ASTCallback.new(Fast.ast(code)) }

  context 'when method' do
    context 'when without any options' do
      let(:code) { 'before_save :method' }

      it { is_expected.to match_callback_ast }
      it { is_expected.to match_method_callback_ast }
      it { is_expected.not_to match_proc_callback_ast }
    end

    %i[if unless].each do |condition|
      context "when with #{condition} condition" do
        context 'when symbol' do
          let(:code) { "before_save :method, #{condition}: :cond" }

          it { is_expected.to match_callback_ast }
          it { is_expected.to match_method_callback_ast }
          it { is_expected.not_to match_proc_callback_ast }

          context 'when multiple' do
            let(:code) { "before_save :method, #{condition}: %i[cond cond2]" }

            it { is_expected.to match_callback_ast }
            it { is_expected.to match_method_callback_ast }
            it { is_expected.not_to match_proc_callback_ast }
          end
        end

        context 'when proc' do
          let(:code) { "before_save :method, #{condition}: ->{}" }

          it { is_expected.to match_callback_ast }
          it { is_expected.to match_method_callback_ast }

          context 'when multiple' do
            let(:code) { "before_save :method, #{condition}: %i[->{}, ->{}]" }

            it { is_expected.to match_callback_ast }
            it { is_expected.to match_method_callback_ast }
            it { is_expected.not_to match_proc_callback_ast }
          end
        end
      end
    end

    context 'when with other options' do
      let(:code) { 'before_save :method, on: :create' }

      it { is_expected.to match_callback_ast }
      it { is_expected.to match_method_callback_ast }
      it { is_expected.not_to match_proc_callback_ast }

      context 'when multiple' do
        let(:code) { 'before_save :method, on: %i[create update destroy]' }

        it { is_expected.to match_callback_ast }
        it { is_expected.to match_method_callback_ast }
        it { is_expected.not_to match_proc_callback_ast }
      end
    end
  end

  context 'when proc' do
    context 'when without any options' do
      let(:code) { 'before_save ->{}' }

      it { is_expected.to match_callback_ast }
      it { is_expected.to match_proc_callback_ast }
      it { is_expected.not_to match_method_callback_ast }
    end

    %i[if unless].each do |condition|
      context "when with #{condition} condition" do
        context 'when symbol' do
          let(:code) { "before_save ->{}, #{condition}: :cond" }

          it { is_expected.to match_callback_ast }
          it { is_expected.to match_proc_callback_ast }
          it { is_expected.not_to match_method_callback_ast }

          context 'when multiple' do
            let(:code) { "before_save ->{}, #{condition}: %i[cond cond2]" }

            it { is_expected.to match_callback_ast }
            it { is_expected.to match_proc_callback_ast }
            it { is_expected.not_to match_method_callback_ast }
          end
        end

        context 'when proc' do
          let(:code) { "before_save ->{}, #{condition}: ->{}" }

          it { is_expected.to match_callback_ast }
          it { is_expected.to match_proc_callback_ast }
          it { is_expected.not_to match_method_callback_ast }

          context 'when multiple' do
            let(:code) { "before_save ->{}, #{condition}: %i[->{}, ->{}]" }

            it { is_expected.to match_callback_ast }
            it { is_expected.to match_proc_callback_ast }
            it { is_expected.not_to match_method_callback_ast }
          end
        end
      end
    end

    context 'when with other options' do
      let(:code) { 'before_save ->{}, on: :create' }

      it { is_expected.to match_callback_ast }
      it { is_expected.to match_proc_callback_ast }
      it { is_expected.not_to match_method_callback_ast }

      context 'when multiple' do
        let(:code) { 'before_save ->{}, on: %i[create update destroy]' }

        it { is_expected.to match_callback_ast }
        it { is_expected.to match_proc_callback_ast }
        it { is_expected.not_to match_method_callback_ast }
      end
    end
  end

  describe "finds conditionals" do
    %i[if unless].each do |condition|
      %i[method1 method2 method3].each do |name|
        context "when singular with name -> #{name}, condition -> #{condition}" do
          let(:code) { "before_save :method_name, #{condition}: :#{name}" }

          it { is_expected.to be_an_ast_callback_with_condition_methods(name) }
        end
      end

      %i[method1 method2 method3].permutation.each do |array|
        context "when multiple with array -> #{array}, condition -> #{condition}" do
          let(:code) { "before_save :method_name, #{condition}: #{array.inspect}" }

          it { is_expected.to be_an_ast_callback_with_condition_methods(*array) }

          context "with if and then unless" do
            let(:code) { "before_save :method_name, if: #{[array.sample].inspect}, unless: #{array.inspect}" }

            it { is_expected.to be_an_ast_callback_with_condition_methods(*array) }
          end

          context "with unless and then if" do
            let(:code) { "before_save :method_name, unless: #{[array.sample].inspect}, if: #{array.inspect}" }

            it { is_expected.to be_an_ast_callback_with_condition_methods(*array) }
          end

          context "with if and then unless" do
            let(:code) { "before_save :method_name, if: #{array.inspect}, unless: #{[array.sample].inspect}" }

            it { is_expected.to be_an_ast_callback_with_condition_methods(*array) }
          end

          context "with unless and then if" do
            let(:code) { "before_save :method_name, unless: #{array.inspect}, if: #{[array.sample].inspect}" }

            it { is_expected.to be_an_ast_callback_with_condition_methods(*array) }
          end
        end
      end
    end
  end

  context 'with different combinations of valid options' do
    procs = [
      '-> do value end',
      "-> do |param|\n value\n end",
      '->() { puts "hello" }',
      '-> { puts "hello" }'
    ]
    positional_arguments = [':method_name'] + procs
    ifs = [':condition_method_name'] + procs
    unlesses = ifs
    ons = [
      ':create',
      '[:destroy]',
      '%i[update destroy]',
    ] + ActiveRecordDiscover::CALLBACK_NAMES.map { |value| ":#{value}" }

    ActiveRecord::Callbacks::CALLBACKS.each do |c|
      positional_arguments.each do |a|
        context "when positional argument is #{a}" do
          let(:code) { "#{c} #{a}" }
          it { is_expected.to match_callback_ast }

          ifs.each do |i|
            context "when positional argument is #{a}, if: #{i}" do
              let(:code) { "#{c} #{a}, if: #{i}" }
              it { is_expected.to match_callback_ast }
            end

            unlesses.each do |u|
              context "when positional argument is #{a}, if: #{i}, unless: #{u}" do
                let(:code) { "#{c} #{a}, if: #{i}, unless: #{u}" }
                it { is_expected.to match_callback_ast }
              end

              ons.each do |o|
                context "when positional argument is #{a}, if: #{i}, unless: #{u}, on: #{o}" do
                  let(:code) { "#{c} #{a}, if: #{i}, unless: #{u}, on: #{o}" }
                  it { is_expected.to match_callback_ast }
                end
              end
            end
          end
        end
      end
    end
  end
end
