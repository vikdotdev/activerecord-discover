module ActiveRecordDiscover
  class Printer
    include ConfigurationHelper
    include LineNumberHelper

    def self.print(metadata_list)
      puts "No callbacks found" if metadata_list.empty?

      metadata_list.each do |metadata|
        new(metadata_list.flatten).format_print
      end
    end

    attr_reader :metadata_list

    def initialize(metadata_list)
      @metadata_list = metadata_list
    end

    def format_print
      metadata_list.each do |metadata|
        source_with_data = metadata.printable_targets.map do |target|
          source = Unparser.unparse(target.ast)
          source = HighlightingFormatter.new(source).format if colors_enabled?
          source = LineNumbersFormatter.new(source, target.ast, metadata.path).format if line_numbers_enabled?

          [source, target, metadata]
        end

        print(source_with_data)
      end
    end

    private

    def print(items)
      puts
      current_path = nil
      items.each do |item|
        source, target, metadata = item

        if print_path?(current_path, metadata.path)
          header = "#{line_numbers_enabled? ? "| #{padded_line_number_arrow} | " : ''}#{path(metadata)}"
          header = header.light_black if colors_enabled?
          puts header
        end

        current_path = metadata.path

        puts source

        if print_separator?(items, item)
          separator = line_numbers_enabled? ? "| #{padded_line_number_dots} |" : ''
          separator = separator.light_black if colors_enabled?
          puts separator
        end
      end
    end

    def path(metadata)
      if show_full_path?
        metadata.path
      else
        Pathname.new(metadata.path).relative_path_from(Rails.root)
      end
    end

    def print_separator?(items, current)
      _, current_target = current
      _, next_target = items[items.find_index(current) + 1]

      items.last != current &&
        current_target.ast.loc.last_line + 1 != next_target.ast.loc.first_line
    end

    def print_path?(previous, current)
      previous != current
    end
  end
end
