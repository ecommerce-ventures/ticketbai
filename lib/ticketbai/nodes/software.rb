module Ticketbai
  module Nodes
    class Software
      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.Software do |xml|
          xml.LicenciaTBAI Ticketbai.config.license_key
          xml.EntidadDesarrolladora do
            xml.NIF Ticketbai.config.developer_company_nif
          end
          xml.Nombre Ticketbai.config.app_name
          xml.Version Ticketbai.config.app_version
        end
      end
    end
  end
end
