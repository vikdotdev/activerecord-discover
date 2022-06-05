module DiscoverRails
  module PathHelper
    include ConfigurationHelper

    def relative_path(target)
      Pathname.new(path(target)).relative_path_from(Rails.root)
    end

    def path_outside_app?(target)
      !path(target).include?(Rails.root.to_s)
    end

    def path(target)
      target.ast&.location&.expression&.source_buffer&.name
    end

    alias_method :full_path, :path

    def format_path(target)
      if show_full_path? || path_outside_app?(target)
        full_path(target)
      else
        relative_path(target)
      end
    end
  end
end
