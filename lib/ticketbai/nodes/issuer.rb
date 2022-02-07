module Ticketbai
  module Nodes
    class Issuer
      def initialize(args = {})
        @issuing_company_nif = args[:issuing_company_nif]
        @issuing_company_name = args[:issuing_company_name]
      end

      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.Emisor do |xml|
          xml.NIF @issuing_company_nif
          xml.ApellidosNombreRazonSocial @issuing_company_name
        end
      end
    end
  end
end
