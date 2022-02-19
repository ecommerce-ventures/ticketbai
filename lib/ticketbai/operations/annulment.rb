module Ticketbai
  module Operations
    class Annulment < Operation
      OPERATION_NAME = :annulment

      ATTRIBUTES = %i[issuing_company_nif issuing_company_name invoice_serial invoice_number invoice_date].freeze

      attr_accessor(*ATTRIBUTES)

      ###
      # @param [String] issuing_company_nif NIF of the taxpayer's company
      # @param [String] issuing_company_name Name of the taxpayer's company
      # @param [String] invoice_serial Invoice's serial number
      # @param [String] invoice_number Invoice's number
      # @param [String] invoice_date Invoices emission date (Format: d-m-Y)
      # @param [String] company_cert The name of the certificate to be used for issuance
      ###
      def initialize(**args)
        super(args)
      end

      def build_document
        @issuer = Ticketbai::Nodes::Issuer.new(issuing_company_nif: @issuing_company_nif, issuing_company_name: @issuing_company_name)

        @invoice_header = Ticketbai::Nodes::InvoiceHeader.new(
          invoice_serial: @invoice_serial,
          invoice_number: @invoice_number,
          invoice_date: @invoice_date
        )

        @software = Ticketbai::Nodes::Software.new

        Ticketbai::Documents::Annulment.new(
          issuer: @issuer,
          invoice_header: @invoice_header,
          software: @software
        ).create
      end
    end
  end
end
