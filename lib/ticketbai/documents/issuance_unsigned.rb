module Ticketbai
  module Documents
    # This document has the pecualiarity that it does not need to be signed and it must be sent to the API without a root node, so it's not considered
    # as a valid XML either. The structure of the document is as follows:
    # <Destinatarios>
    # ...
    # ...
    # </Destinatarios>
    # <CabeceraFactura>
    # ...
    # ...
    # </CabeceraFactura>
    # <DatosFactura>
    #  ...
    #  ...
    # </DatosFactura>
    # <TipoDesglose>
    # ...
    # ...
    # </TipoDesglose>
    #
    # The document is created with a temporary root node (TicketBai), and after creating it, it's returned without the root node.
    class IssuanceUnsigned
      ###
      # @param [Ticketbai::Nodes::Receiver] receiver
      # @param [Ticketbai::Nodes::InvoiceHeader] invoice_header
      # @param [Ticketbai::Nodes::InvoiceData] invoice_data
      # @param [Ticketbai::Nodes::BreakdownType] breakdown_type
      ###
      def initialize(**args)
        @receiver = args[:receiver]
        @invoice_header = args[:invoice_header]
        @invoice_data = args[:invoice_data]
        @breakdown_type = args[:breakdown_type]
      end

      # @return [String]
      def create
        builder = Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
          xml.TicketBai do
            @receiver&.build_xml(xml)
            @invoice_header.build_xml(xml)
            @invoice_data.build_xml(xml)
            @breakdown_type.build_xml(xml)
          end
        end

        filter_root_node(builder)
      end

      private

      def filter_root_node(builder)
        Nokogiri::XML(builder.to_xml).at('TicketBai').children.to_xml
      end
    end
  end
end
