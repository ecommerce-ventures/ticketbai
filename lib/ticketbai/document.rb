module Ticketbai
  class Document
    TBAI_VERSION = '1.2'.freeze

    def create
      raise NotImplementedError, 'Must implement this method'
    end

    private

    def modify_xml_root_name(builder)
      builder.doc.root.name = self.class::ROOT_NAME
    end
  end
end
