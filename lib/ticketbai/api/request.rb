require 'faraday'
require 'json'
require 'zlib'

module Ticketbai
  module Api
    class Request
      TEST_PRESENTATION_ENDPOINT = 'https://pruesarrerak.bizkaia.eus/N3B4000M/aurkezpena'.freeze
      LIVE_PRESENTATION_ENDPOINT = 'https://sarrerak.bizkaia.eus/N3B4000M/aurkezpena'.freeze
      TEST_QUERY_ENDPOINT = 'https://pruesarrerak.bizkaia.eus/N3B4001M/kontsulta'.freeze

      # OPERATIONS
      # issuance_unsigned: (invoices issued without guarantor software): When a TicketBai file has been rejected due to a poorly generated XML result,
      #                    taking into account that the TicketBAI file cannot be generated again and that its information must be sent, it must be done by
      #                    indicating the subchapter Invoices issued no guarantor software
      # issuance:  New invoices issued that we want to register using the guarantor software
      # annulment: Cancel invoices that we have previously registered using the guarantor software
      SUPPORTED_OPERATIONS = [
        Ticketbai::Operations::Issuance::OPERATION_NAME,
        Ticketbai::Operations::Annulment::OPERATION_NAME,
        Ticketbai::Operations::IssuanceUnsigned::OPERATION_NAME
      ].freeze

      OPERATION_MAPPING = {
        issuance: 'A00',
        annulment: 'AN0',
        modify: 'M00',
        query: 'C00',
        issuance_unsigned: 'A00'
      }.freeze

      LROE_MODEL = '240'.freeze
      LROE_CHAPTER = '1'.freeze

      ###
      # @param [Array] issued_invoices TicketBAI XML file(s) string (Max: 1000)
      # @param [String] company_name Name of the taxpayer's company
      # @param [String] year Fiscal year
      # @param [Symbol] certificate_name Taxpayer's certificate name
      # @param [Symbol] operation Operation name
      ###
      def initialize(issued_invoices:, nif:, company_name:, year:, certificate_name:, operation:)
        raise ArgumentError, "Unsupported operation: #{operation}" unless SUPPORTED_OPERATIONS.include? operation.downcase.to_sym

        @issued_invoices = Array(issued_invoices)
        @nif = nif
        @company_name = company_name
        @year = year
        @company_cert = Ticketbai.config.certificates[certificate_name.to_sym]
        @operation = operation.downcase.to_sym
      end

      def execute
        client = Client.new(
          url: presentation_endpoint,
          headers: headers,
          body: gzip_body,
          company_cert: @company_cert
        )

        client.execute
      end

      private

      def gzip_body
        gz = StringIO.new('')
        z = Zlib::GzipWriter.new(gz)
        z.write Nokogiri::XML(build_document)
        z.close

        StringIO.new(gz.string).read
      end

      def build_document
        @lroe_header = Ticketbai::Nodes::LroeHeader.new(
          year: @year,
          nif: @nif,
          company_name: @company_name,
          operation: OPERATION_MAPPING[@operation],
          subchapter: subchapter
        )

        @lroe_issued_invoices = Ticketbai::Nodes::LroeIssuedInvoices.new(operation: @operation, issued_invoices: @issued_invoices)

        Ticketbai::Documents::ApiPayload.new(
          operation: @operation,
          lroe_issued_invoices: @lroe_issued_invoices,
          lroe_header: @lroe_header
        ).create
      end

      def presentation_endpoint
        if Ticketbai.live?
          LIVE_PRESENTATION_ENDPOINT
        else
          TEST_PRESENTATION_ENDPOINT
        end
      end

      def subchapter
        @operation == :issuance_unsigned ? '1.2' : '1.1'
      end

      def headers
        {
          'Content-Type' => 'application/octet-stream',
          'Content-Encoding' => 'gzip',
          'eus-bizkaia-n3-version' => '1.0',
          'eus-bizkaia-n3-content-type' => 'application/xml',
          'eus-bizkaia-n3-data' => lroe_header_data
        }
      end

      def lroe_header_data
        {
          con: 'LROE',
          apa: subchapter,
          inte: { nif: @nif, nrs: @company_name },
          drs: { mode: LROE_MODEL, ejer: @year }
        }.to_json
      end
    end
  end
end
