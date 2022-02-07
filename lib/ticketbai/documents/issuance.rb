module Ticketbai
  module Documents
    class Issuance < Document
      ROOT_NAME = 'T:TicketBai'.freeze
      XMLNS = {
        'xmlns:T' => 'urn:ticketbai:emision'
      }.freeze

      ###
      # @param [Ticketbai::Nodes::Isuer] issuer
      # @param [Ticketbai::Nodes::Receiver] receiver
      # @param [Ticketbai::Nodes::InvoiceHeader] invoice_header
      # @param [Ticketbai::Nodes::InvoiceData] invoice_data
      # @param [Ticketbai::Nodes::BreakdownType] breakdown_type
      # @param [Ticketbai::Nodes::InvoiceChaining] invoice_chaining
      # @param [Ticketbai::Nodes::Software] software
      ###
      def initialize(**args)
        @issuer = args[:issuer]
        @receiver = args[:receiver]
        @invoice_header = args[:invoice_header]
        @invoice_data = args[:invoice_data]
        @breakdown_type = args[:breakdown_type]
        @invoice_chaining = args[:invoice_chaining]
        @software = args[:software]
      end

      # @return [Nokogiri::XML::Builder]
      def create
        builder = Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
          xml.TicketBai(XMLNS) do
            xml.Cabecera do
              xml.IDVersionTBAI TBAI_VERSION
            end
            xml.Sujetos do
              @issuer.build_xml(xml)
              @receiver&.build_xml(xml)
            end
            xml.Factura do
              @invoice_header.build_xml(xml)
              @invoice_data.build_xml(xml)
              @breakdown_type.build_xml(xml)
            end
            xml.HuellaTBAI do
              @invoice_chaining&.build_xml(xml)
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
