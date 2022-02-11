module Ticketbai
  module Api
    class Client
      KO_RESPONSE = :incorrecto
      OK_RESPONSE = :correcto
      PARTIALLY_OK_RESPONSE = :parcialmentecorrecto

      def initialize(url:, headers:, body:, company_cert:)
        @url = url
        @headers = headers
        @body = body
        @company_cert = company_cert
      end

      def execute
        response = connection.post do |req|
          req.url(@url)
          req.headers = @headers
          req.body = @body
        end

        ResponseParser.new(response).to_h
      end

      private

      def connection
        Faraday.new(ssl: ssl) do |builder|
          builder.request :multipart
          builder.response(:logger) unless Ticketbai.test?
          builder.adapter Faraday.default_adapter
        end
      end

      def ssl
        {
          client_key: client_key,
          client_cert: client_cert
        }
      end

      def client_key
        p12.key
      end

      def client_cert
        p12.certificate
      end

      def p12
        OpenSSL::PKCS12.new(p12_file, p12_password)
      end

      def p12_file
        Base64.decode64(@company_cert[:cert])
      end

      def p12_password
        @company_cert[:key]
      end
    end
  end
end
