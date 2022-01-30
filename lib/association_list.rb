module ActiveRecordDiscover
  class AssociationList
    extend ActiveRecordDiscover::Helpers

    def self.all(model)
      []
    end
  end
end
