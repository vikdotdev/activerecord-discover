require 'rails_helper'

RSpec.describe ActiveRecordDiscover::ASTCallback do
  subject { described_class.from_string(code) }

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
      # TODO: add more syntax variants
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

  context 'with different combinations of valid options', :slow do
    # TODO: make a permutator for this as spec helper? and tag this as slow spec
    procs = [
      '-> do value end',
      "-> do |param|\n value\n end",
      '->() { puts "hello" }',
      '-> { puts "hello" }'
    ]
    pos_arguments = [':method_name'] + procs
    ifs = [':value'] + procs
    unlesses = ifs
    ons = [
      ':create',
      '[:destroy]',
      '%i[update destroy]',
    ] + ActiveRecordDiscover::CALLBACK_NAMES.map { |value| ":#{value}" }

    ActiveRecord::Callbacks::CALLBACKS.each do |callback_sym|
      pos_arguments.each do |a|
        context "when positional argument is #{a}" do
          let(:code) { "#{callback_sym} #{a}" }
          it { is_expected.to match_callback_ast }

          ifs.each do |i|
            context "when positional argument is #{a}, if: #{i}" do
              let(:code) { "#{callback_sym} #{a}, if: #{i}" }
              it { is_expected.to match_callback_ast }
            end

            unlesses.each do |u|
              context "when positional argument is #{a}, if: #{i}, unless: #{u}" do
                let(:code) { "#{callback_sym} #{a}, if: #{i}, unless: #{u}" }
                it { is_expected.to match_callback_ast }
              end

              ons.each do |o|
                context "when positional argument is #{a}, if: #{i}, unless: #{u}, on: #{o}" do
                  let(:code) { "#{callback_sym} #{a}, if: #{i}, unless: #{u}, on: #{o}" }
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
