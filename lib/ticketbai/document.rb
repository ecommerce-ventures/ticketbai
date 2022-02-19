module Ticketbai
  class Document
    TBAI_VERSION = '1.2'.freeze

    def initialize(args)
      self.class::ATTRIBUTES.each do |p|
        instance_variable_set "@#{p}", args[p]
      end
    end

    def create
      raise NotImplementedError, 'Must implement this method'
    end

    private

    def modify_xml_root_name(builder)
      builder.doc.root.name = self.class::ROOT_NAME
    end
  end
end
