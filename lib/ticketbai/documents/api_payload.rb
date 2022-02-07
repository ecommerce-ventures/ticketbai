module Ticketbai
  module Documents
    class ApiPayload
      ROOT_NAME_MAPPING = {
        issuance: 'lrpjfecsgap:LROEPJ240FacturasEmitidasConSGAltaPeticion',
        annulment: 'lrpjfecsgap:LROEPJ240FacturasEmitidasConSGAnulacionPeticion',
        issuance_unsigned: 'lrpjfecsgap:LROEPJ240FacturasEmitidasSinSGAltaModifPeticion'
      }.freeze
      SCHEME_MAPPING = {
        issuance: 'https://www.batuz.eus/fitxategiak/batuz/LROE/esquemas/LROE_PJ_240_1_1_FacturasEmitidas_ConSG_AltaPeticion_V1_0_2.xsd',
        annulment: 'https://www.batuz.eus/fitxategiak/batuz/LROE/esquemas/LROE_PJ_240_1_1_FacturasEmitidas_ConSG_AnulacionPeticion_V1_0_0.xsd',
        issuance_unsigned: 'https://www.batuz.eus/fitxategiak/batuz/LROE/esquemas/LROE_PJ_240_1_2_FacturasEmitidas_SinSG_AltaModifPeticion_V1_0_1.xsd'
      }.freeze

      ###
      # @param [Ticketbai::Nodes::LroeHeader] lroe_header
      # @param [Ticketbai::Nodes::LroeIssuedInvoices] lroe_issued_invoices
      # @param [Symbol] operation
      ###
      def initialize(**args)
        @lroe_header = args[:lroe_header]
        @lroe_issued_invoices = args[:lroe_issued_invoices]
        @operation = args[:operation]
      end

      # @return [Nokogiri::XML::Builder]
      def create
        builder = Nokogiri::XML::Builder.new(encoding: 'utf-8') do |xml|
          xml.ROOT_NAME('xmlns:lrpjfecsgap' => SCHEME_MAPPING[@operation]) do
            @lroe_header.build_xml(xml)
            @lroe_issued_invoices.build_xml(xml)
          end
        end

        modify_xml_root_name(builder)

        builder.to_xml
      end

      private

      def modify_xml_root_name(builder)
        builder.doc.root.name = ROOT_NAME_MAPPING[@operation]
      end
    end
  end
end
