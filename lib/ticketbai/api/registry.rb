module Ticketbai
  module Api
    class Registry
      def initialize(attributes)
        @attributes = attributes
      end

      def number
        @attributes.at_css('NumFactura')&.children&.last&.text
      end

      def uploaded
        @attributes.at_css('CodigoErrorRegistro').nil?
      end

      def error_code
        @attributes.at_css('CodigoErrorRegistro')&.children&.last&.text
      end

      def error_message
        @attributes.at_css('DescripcionErrorRegistroES')&.children&.last&.text
      end

      def to_h
        {
          number: number,
          uploaded: uploaded,
          error_code: error_code,
          error_message: error_message
        }
      end
    end
  end
end
