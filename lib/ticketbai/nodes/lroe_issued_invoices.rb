module Ticketbai
  module Nodes
    class LroeIssuedInvoices
      def initialize(args = {})
        @issued_invoices = args[:issued_invoices]
        @operation = args[:operation]
      end

      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.FacturasEmitidas do |xml|
          @issued_invoices.each do |issued_invoice|
            xml.FacturaEmitida do
              case @operation
              when :annulment
                xml.AnulacionTicketBai Base64.strict_encode64(issued_invoice)
              when :issuance
                xml.TicketBai Base64.strict_encode64(issued_invoice)
              when :issuance_unsigned
                xml << issued_invoice
              end
            end
          end
        end
      end
    end
  end
end
