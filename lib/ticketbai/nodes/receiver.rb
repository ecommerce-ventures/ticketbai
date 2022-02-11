module Ticketbai
  module Nodes
    class Receiver
      # ID TYPES
      # 02: NIF-IVA
      # 03: Pasaporte
      # 04: Documento oficial de identificacion expedido por el pais o territorio de residencia
      # 05: Certificado de residencia
      # 06: Otro documento probatorio

      def initialize(args = {})
        @receiver_country = args[:receiver_country]
        @receiver_nif = args[:receiver_nif]
        @receiver_name = args[:receiver_name]
      end

      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.Destinatarios do |xml|
          xml.IDDestinatario do
            if @receiver_country == 'ES'
              xml.NIF @receiver_nif
            else
              xml.IDOtro do
                xml.CodigoPais @receiver_country
                xml.IDType '04'
                xml.ID @receiver_nif
              end
            end
            xml.ApellidosNombreRazonSocial @receiver_name
          end
        end
      end
    end
  end
end
