module ActiveRecordDiscover
  # TODO handle ast_methods that are not found better, current approach does not work?
  # TODO implement DebugPrinter which will print the usual stuff + debug info about each
  # entity
  class Printer
    include ConfigurationHelper
    include LineHelper
    include HighlightHelper
    extend  HighlightHelper
    include PathHelper

    def self.print_all(callback_group_list)
      puts gray_colored("No callbacks found") if callback_group_list.empty?

      callback_group_list.each do |callback_group|
        new(callback_group).format_print
      end
    end

    attr_reader :callback_group

    def initialize(callback_group)
      @callback_group = callback_group
    end

    def format_print
      pairs = callback_group.printable_targets.map do |target|
        source = unindent_lines_for(target.ast)
        source = highlight_format_source(source) if colors_enabled? # && source.present?
        source = line_number_source(source, target.ast) if line_numbers_enabled?

        [source, target]
      end

      print(pairs)
    end

    private

    def print(pairs)
      puts
      current_path = nil
      pairs.each do |pair|
        source, target = pair

        if print_header?(current_path, path(target))
          print_header(format_path(target))
        elsif method_blank?(target)
          print_header(
            "Could not find source for #{target.name} method.",
            padded_line_number_error
          )
        end

        current_path = path(target)

        puts source

        print_separator if print_separator?(pairs, pair)
      end
    end

    def next_target(pairs, current)
      pairs[pairs.find_index(current) + 1].last
    end

    def print_separator?(items, current)
      _, current_target = current
      _, next_target = items[items.find_index(current) + 1]

      items.last != current &&
        (path(current_target) != path(next_target) ||
         current_target.ast.loc.last_line + 1 != next_target.ast.loc.first_line)
    end

    def print_separator(symbol = nil)
      symbol ||= padded_line_number_dots
      separator = line_numbers_enabled? ? "| #{symbol} |" : ''
      puts gray_colored(separator)
    end

    def print_header?(previous, current)
      return false if current.nil?

      previous != current
    end

    def print_header(text, symbol = nil)
      symbol ||= padded_line_number_arrow
      header = "#{line_numbers_enabled? ? "| #{symbol} | " : ''}#{text}"
      puts gray_colored(header)
    end

    def method_blank?(target)
      target.is_a?(ASTMethod) && target.blank?
    end
  end
end
