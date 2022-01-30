module ActiveRecordDiscover
  class ValidationList
    extend ActiveRecordDiscover::Helpers

    def self.all(model)
      []
    end
  end
end
