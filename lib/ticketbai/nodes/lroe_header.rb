module Ticketbai
  module Nodes
    class LroeHeader
      def initialize(args = {})
        @year = args[:year]
        @nif = args[:nif]
        @company_name = args[:company_name]
        @operation = args[:operation]
        @subchapter = args[:subchapter]
      end

      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.Cabecera do |xml|
          xml.Modelo Ticketbai::Api::Request::LROE_MODEL
          xml.Capitulo Ticketbai::Api::Request::LROE_CHAPTER
          xml.Subcapitulo @subchapter
          xml.Operacion @operation
          xml.Version '1.0'
          xml.Ejercicio @year
          xml.ObligadoTributario do
            xml.NIF @nif
            xml.ApellidosNombreRazonSocial @company_name
          end
        end
      end
    end
  end
end
