module Ticketbai
  module Documents
    class Annulment < Document
      ROOT_NAME = 'T:AnulaTicketBai'.freeze
      XMLNS = {
        'xmlns:T' => 'urn:ticketbai:anulacion'
      }.freeze

      ###
      # @param [Ticketbai::Nodes::Isuer] issuer
      # @param [Ticketbai::Nodes::InvoiceHeader] invoice_header
      # @param [Ticketbai::Nodes::Software] software
      ###
      def initialize(**args)
        @issuer = args[:issuer]
        @invoice_header = args[:invoice_header]
        @software = args[:software]
      end

      # @return [Nokogiri::XML::Builder]
      def create
        builder = Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
          xml.TicketBai(XMLNS) do
            xml.Cabecera do
              xml.IDVersionTBAI TBAI_VERSION
            end
            xml.IDFactura do
              @issuer.build_xml(xml)
              @invoice_header.build_xml(xml)
            end
            xml.HuellaTBAI do
              @software.build_xml(xml)
            end
          end
        end

        modify_xml_root_name(builder)

        builder
      end
    end
  end
end
