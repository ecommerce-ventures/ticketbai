module Ticketbai
  module Operations
    class Annulment < Operation
      attr_reader :company_cert
      # Sujetos > Emisor
      attr_reader :issuing_company_nif, :issuing_company_name
      # Factura > CabeceraFactura
      attr_reader :invoice_serial, :invoice_number, :invoice_date

      OPERATION_NAME = :annulment

      ###
      # @param issuing_company_nif:  NIF of the taxpayer's company
      # @param issuing_company_name: Name of the taxpayer's company
      # @param invoice_serial: Invoices serial number
      # @param invoice_number: Invoices number
      # @param invoice_date: Invoices emission date (Format: d-m-Y)
      # @param company_cert: The name of the certificate to be used for issuance
      ###
      def initialize(**args)
        @issuing_company_nif = args[:issuing_company_nif]
        @issuing_company_name = args[:issuing_company_name]
        @invoice_serial = args[:invoice_serial]
        @invoice_number = args[:invoice_number]
        @invoice_date = args[:invoice_date]

        @company_cert = Ticketbai.config.certificates[args[:company_cert]]
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
