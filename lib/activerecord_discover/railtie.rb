module ActiveRecordDiscover
  class Railtie < ::Rails::Railtie
    console do
      TOPLEVEL_BINDING.eval('self').extend ActiveRecordDiscover::ConsoleMethods
    end
  end
end
