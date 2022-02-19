module ActiveRecordDiscover
  class Printer
    include ConfigurationHelper
    include LineNumberHelper

    def self.print(metadata_list)
      metadata_list = metadata_list.flatten

      puts "No callbacks found" if metadata_list.empty?

      metadata_list.each do |metadata|
        new(metadata).format_print
      end
    end

    attr_reader :metadata

    def initialize(metadata)
      @metadata = metadata
    end

    def format_print
      pairs = metadata.printable_targets.map do |target|
        source = Unparser.unparse(target.ast)
        source = HighlightingFormatter.new(source).format if colors_enabled?
        source = LineNumbersFormatter.new(source, target.ast, path(target)).format if line_numbers_enabled?

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

        if print_path?(current_path, path(target))
          header = "#{line_numbers_enabled? ? "| #{padded_line_number_arrow} | " : ''}#{format_path(target)}"
          header = header.light_black if colors_enabled?
          puts header
        end

        current_path = path(target)

        puts source

        if print_separator?(pairs, pair)
          separator = line_numbers_enabled? ? "| #{padded_line_number_dots} |" : ''
          separator = separator.light_black if colors_enabled?
          puts separator
        end
      end
    end

    def path(target)
      target.ast.location.expression.source_buffer.name
    end

    def format_path(target)
      if show_full_path?
        path(target)
      else
        Pathname.new(path(target)).relative_path_from(Rails.root)
      end
    end

    def next_target(pairs, current)
      items[items.find_index(current) + 1].last
    end

    def print_separator?(items, current)
      _, current_target = current
      _, next_target = items[items.find_index(current) + 1]

      items.last != current &&
        (path(current_target) != path(next_target) ||
         current_target.ast.loc.last_line + 1 != next_target.ast.loc.first_line)
    end

    def print_path?(previous, current)
      previous != current
    end
  end
end
