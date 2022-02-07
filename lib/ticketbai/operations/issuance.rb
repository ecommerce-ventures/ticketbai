module Ticketbai
  module Operations
    class Issuance < Operation
      attr_reader :company_cert
      # Sujetos > Emisor
      attr_reader :issuing_company_nif, :issuing_company_name
      # Sujetos > Destinatario
      attr_reader :receiver_nif, :receiver_name
      # Factura > CabeceraFactura
      attr_reader :invoice_serial, :invoice_number, :invoice_date, :invoice_time, :simplified_invoice
      # Factura > DatosFactura
      attr_reader :invoice_description, :invoice_total, :invoice_vat_key
      # Factura > TipoDesglose
      attr_reader :invoice_amount, :invoice_vat, :invoice_vat_total
      # HuellaTBAI > EncadenamientoFacturaAnterior
      attr_reader :prev_invoice_number, :prev_invoice_signature, :prev_invoice_date

      DEFAULT_VAT_KEY = '01'.freeze
      OPERATION_NAME = :issuance

      ###
      # @param [String] issuing_company_nif NIF of the taxpayer's company
      # @param [String] issuing_company_name Name of the taxpayer's company
      # @param [String] receiver_nif Spanish NIF or official identification document in case of being another country
      # @param [String] receiver_name  Name of the receiver
      # @param [String] receiver_country Country code of the receiver (Ex: ES|DE)
      # @param [Boolean] receiver_in_eu The receiver residence is in Europe?
      # @param [String] invoice_serial Invoices serial number
      # @param [String] invoice_number Invoices number
      # @param [String] invoice_date Invoices emission date (Format: d-m-Y)
      # @param [String] invoice_time  Invoices emission time (Format: H:M:S)
      # @param [Boolean] simplified_invoice is a simplified invoice?
      # @param [String] invoice_description Invoices description text
      # @param [String] invoice_total Total invoice amount
      # @param [String] invoice_vat_key Key of the VAT regime
      # @param [String] invoice_amount Taxable base of the invoice
      # @param [Float] invoice_vat Invoice VAT (Ex: 21.0)
      # @param [String] invoice_vat_total Invoices number
      # @param [String] prev_invoice_number Number of the last invoice generated
      # @param [String] prev_invoice_signature Signature of the last invoice generated
      # @param [String] prev_invoice_date Emission date of the last invoice generated
      # @param [Symbol] company_cert: The name of the certificate to be used for issuance
      ###
      def initialize(**args)
        @issuing_company_nif = args[:issuing_company_nif]
        @issuing_company_name = args[:issuing_company_name]
        @receiver_nif = args[:receiver_nif]&.strip
        @receiver_name = args[:receiver_name]
        @receiver_country = args[:receiver_country]&.upcase || 'ES'
        @receiver_in_eu = args[:receiver_in_eu]
        @invoice_serial = args[:invoice_serial]
        @invoice_number = args[:invoice_number]
        @invoice_date = args[:invoice_date]
        @invoice_time = args[:invoice_time]
        @simplified_invoice = args[:simplified_invoice]
        @invoice_description = args[:invoice_description]
        @invoice_total = args[:invoice_total]
        @invoice_vat_key = args[:invoice_vat_key]
        @invoice_amount = args[:invoice_amount]
        @invoice_vat = args[:invoice_vat]
        @invoice_vat_total = args[:invoice_vat_total]
        @prev_invoice_number = args[:prev_invoice_number]
        @prev_invoice_signature = args[:prev_invoice_signature]
        @prev_invoice_date = args[:prev_invoice_date]

        @company_cert = Ticketbai.config.certificates[args[:company_cert]]
      end

      def build_document
        @issuer = Ticketbai::Nodes::Issuer.new(issuing_company_nif: @issuing_company_nif, issuing_company_name: @issuing_company_name)

        if @receiver_nif && @receiver_name
          @receiver = Ticketbai::Nodes::Receiver.new(receiver_country: @receiver_country, receiver_nif: @receiver_nif, receiver_name: @receiver_name)
        end

        @invoice_header = Ticketbai::Nodes::InvoiceHeader.new(
          invoice_serial: @invoice_serial,
          invoice_number: @invoice_number,
          invoice_date: @invoice_date,
          invoice_time: @invoice_time,
          simplified_invoice: @simplified_invoice
        )
        @invoice_data = Ticketbai::Nodes::InvoiceData.new(
          invoice_description: @invoice_description,
          invoice_total: @invoice_total,
          invoice_vat_key: @invoice_vat_key
        )
        @breakdown_type = Ticketbai::Nodes::BreakdownType.new(
          receiver_country: @receiver_country,
          invoice_amount: @invoice_amount,
          invoice_vat: @invoice_vat,
          invoice_vat_total: @invoice_vat_total,
          receiver_in_eu: @receiver_in_eu,
          simplified_invoice: @simplified_invoice
        )
        if @prev_invoice_number && @prev_invoice_date && @prev_invoice_signature
          @invoice_chaining = Ticketbai::Nodes::InvoiceChaining.new(
            prev_invoice_serial: @prev_invoice_serial,
            prev_invoice_number: @prev_invoice_number,
            prev_invoice_date: @prev_invoice_date,
            prev_invoice_signature: @prev_invoice_signature
          )
        end

        @software = Ticketbai::Nodes::Software.new

        Ticketbai::Documents::Issuance.new(
          issuer: @issuer,
          receiver: @receiver,
          invoice_header: @invoice_header,
          invoice_data: @invoice_data,
          breakdown_type: @breakdown_type,
          invoice_chaining: @invoice_chaining,
          software: @software
        ).create
      end
    end
  end
end
