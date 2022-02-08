module Ticketbai
  module Api
    class ResponseParser
      def initialize(raw_response)
        @raw_response = raw_response
      end

      def status
        @raw_response.headers['eus-bizkaia-n3-tipo-respuesta'].downcase.to_sym
      end

      def identifier
        @raw_response.headers['eus-bizkaia-n3-identificativo']
      end

      def message
        @raw_response.headers['eus-bizkaia-n3-mensaje-respuesta']&.force_encoding('ISO-8859-1')&.encode('UTF-8')
      end

      def registries
        return [] unless @raw_response.body

        Nokogiri::XML(@raw_response.body).css('Registros Registro').map { |attributes| Registry.new(attributes) }
      end

      def to_h
        {
          status: status,
          identifier: identifier,
          message: message,
          registries: registries.map(&:to_h)
        }
      end
    end
  end
end
