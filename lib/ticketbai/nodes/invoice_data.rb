module Ticketbai
  module Nodes
    class InvoiceData
      def initialize(args = {})
        @invoice_description = args[:invoice_description]
        @invoice_total = args[:invoice_total]
        @invoice_vat_key = args[:invoice_vat_key]
      end

      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.DatosFactura do |xml|
          xml.DescripcionFactura @invoice_description
          xml.ImporteTotalFactura @invoice_total
          xml.Claves do
            xml.IDClave do
              xml.ClaveRegimenIvaOpTrascendencia @invoice_vat_key
            end
          end
        end
      end
    end
  end
end
