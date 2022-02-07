module Ticketbai
  module Nodes
    class InvoiceHeader
      SIMPLIFIED_INVOICE = 'S'.freeze

      def initialize(args = {})
        @invoice_serial = args[:invoice_serial]
        @invoice_number = args[:invoice_number]
        @invoice_date = args[:invoice_date]
        @invoice_time = args[:invoice_time]
        @simplified_invoice = args[:simplified_invoice]
      end

      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.CabeceraFactura do |xml|
          xml.SerieFactura @invoice_serial
          xml.NumFactura @invoice_number
          xml.FechaExpedicionFactura @invoice_date
          xml.HoraExpedicionFactura @invoice_time if @invoice_time
          xml.FacturaSimplificada SIMPLIFIED_INVOICE if @simplified_invoice
        end
      end
    end
  end
end
