module Ticketbai
  module Nodes
    class InvoiceChaining
      def initialize(args = {})
        @prev_invoice_serial = args[:prev_invoice_serial]
        @prev_invoice_number = args[:prev_invoice_number]
        @prev_invoice_date = args[:prev_invoice_date]
        @prev_invoice_signature = args[:prev_invoice_signature]
      end

      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.EncadenamientoFacturaAnterior do |xml|
          xml.SerieFacturaAnterior @prev_invoice_serial if @prev_invoice_serial
          xml.NumFacturaAnterior @prev_invoice_number
          xml.FechaExpedicionFacturaAnterior @prev_invoice_date
          xml.SignatureValueFirmaFacturaAnterior @prev_invoice_signature
        end
      end
    end
  end
end
