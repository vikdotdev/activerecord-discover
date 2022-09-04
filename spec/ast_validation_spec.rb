require 'rails_helper'

RSpec.describe ASTValidation do
  def ast(string)
    described_class.new(string.to_ast, dummy_model)
  end

  describe "when with validates" do
    describe "when no options" do
      [
        'validates_presence_of :field',
        'validates_absence_of :field',
        'validates_uniqueness_of :field',
        'validates_acceptance_of :field',
        'validates_confirmation_of :field',
        'validates_associated :field',
        'validates_inclusion_of :field',
        'validates_exclusion_of :field',
        'validates_format_of :field',
        'validates_length_of :field',
        'validates_size_of :field',
        'validates_numericality_of :field',
        'validates! :field, presence: true',
        'validates :field, presence: true',
        'validates :field, absence: true',
        'validates :field, uniqueness: true',
        'validates :field, acceptance: true',
        'validates :field, confirmation: true',
        'validates :field, comparison: { greater_than: :other }',
        'validates :field, inclusion: { in: [:hello] }',
        'validates :field, exclusion: { in: [:bye] }',
        'validates :field, format: { with: /hello/, without: /bye/ }',
        'validates :field, length: { in: 10..12 }',
        'validates :field, numericality: { only_integer: true }',
        'validates :field, :field_2, presence: true'
      ].each do |syntax_variant|
        it "matches with #{syntax_variant.squish}" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end

    describe "when with options" do
      [
        'validates :example, presence: true',
        'validates :example, presence: true, allow_blank: true',
        'validates :example, presence: true, allow_nil: true',
        'validates :example, presence: true, strict: true',
        'validates :example, presence: true, on: :create',
        'validates :example, presence: true, on: [:create, :custom]',
        'validates :example, presence: true, if: :example, unless: :example',
        'validates :example, presence: true, if: ->{}, unless: ->{}',
        'validates :example, presence: true, if: [->{}, :example], unless: [->{}, :example]',
        'validates_presence_of :field, if: :example',
        'validates :example, example_2, presence: true'
      ].each do |syntax_variant|
        it "matches with '#{syntax_variant.squish}'" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end
  end

  describe "when with validate" do
    describe "when with a method" do
      ["validate :example", "validate :example, :example_2"].each do |syntax_variant|
        it "matches with #{syntax_variant.squish}" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end

    describe "when with a proc" do
      [
        'validate ->{}',
        'validate ->{}, ->{}',
        <<-CODE,
          validate do
          end
        CODE
        <<-CODE,
          validate -> do
          end
        CODE
        <<-CODE
          validate -> do
          end, if: :a
        CODE
      ].each do |syntax_variant|
        it "matches with #{syntax_variant.squish}" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end

    describe 'when with a method and a proc' do
      [
        'validate :example, ->{}',
        <<-CODE,
          validate :example do
          end
        CODE
        <<-CODE,
          validate :example, -> do
          end
        CODE
        <<-CODE,
          validate :example, :example, -> do
          end
        CODE
        <<-CODE
          validate :example, :example, -> do
          end, :example
        CODE
      ].each do |syntax_variant|
        it "matches with #{syntax_variant.squish}" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end
  end

  describe 'when with validates_each' do
    describe 'when no options' do
      [
        <<-CODE,
          validates_each :example do
          end
        CODE
        <<-CODE
          validates_each :example, :example_2 do
          end
        CODE
      ].each do |syntax_variant|
        it "matches with #{syntax_variant.squish}" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end

    describe "when with options" do
      [
        <<-CODE,
          validates_each :example, allow_blank: true do
          end
        CODE
        <<-CODE,
          validates_each :example, allow_nil: true do
          end
        CODE
        <<-CODE,
          validates_each :example, strict: true do
          end
        CODE
        <<-CODE,
          validates_each :example, on: :create do
          end
        CODE
        <<-CODE,
          validates_each :example, on: [:create, :custom] do
          end
        CODE
        <<-CODE,
          validates_each :example, if: :example, unless: :example do
          end
        CODE
        <<-CODE,
          validates_each :example, if: ->{}, unless: ->{} do
          end
        CODE
        <<-CODE
          validates_each :example, if: [->{}, :example], unless: [->{}, :example] do
          end
        CODE
      ].each do |syntax_variant|
        it "matches with #{syntax_variant.squish}" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end
  end

  describe 'when with validates_with' do
    describe 'when with no options' do
      ['validates_with Example', 'validates_with Example, Example2'].each do |syntax_variant|
        it "matches with #{syntax_variant.squish}" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end

    describe 'when with options' do
      [
        'validates_with Example, allow_blank: true',
        'validates_with Example, allow_nil: true',
        'validates_with Example, strict: true',
        'validates_with Example, on: :create',
        'validates_with Example, on: [:create, :custom]',
        'validates_with Example, if: :example, unless: :example',
        'validates_with Example, if: ->{}, unless: ->{}',
        'validates_with Example, if: [->{}, :example], unless: [->{}, :example]'
      ].each do |syntax_variant|
        it "matches with '#{syntax_variant.squish}'" do
          assert_ast ast(syntax_variant), syntax_variant
        end
      end
    end
  end
end
