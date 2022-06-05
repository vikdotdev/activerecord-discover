module DiscoverRails
  class Railtie < ::Rails::Railtie
    console do
      TOPLEVEL_BINDING.eval('self').extend DiscoverRails::ConsoleMethods
    end
  end
end
