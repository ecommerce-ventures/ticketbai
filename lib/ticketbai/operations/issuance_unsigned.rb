module Ticketbai
  module Operations
    # In this operation, the document is not signed and it is not encoded in Base64 when making the request to the API as issuance and annulment
    # operations, instead it is directly appended to the tag FacturaEmitida of the api payload document.
    class IssuanceUnsigned
      # Sujetos > Destinatario
      attr_reader :receiver_nif, :receiver_name
      # Factura > CabeceraFactura
      attr_reader :invoice_serial, :invoice_number, :invoice_date, :invoice_time
      # Factura > DatosFactura
      attr_reader :invoice_description, :invoice_total, :invoice_vat_key
      # Factura > TipoDesglose
      attr_reader :invoice_amount, :invoice_vat, :invoice_vat_total

      OPERATION_NAME = :issuance_unsigned

      ###
      # @param receiver_nif: Spanish NIF or official identification document in case of being another country
      # @param receiver_name: Name of the receiver
      # @param receiver_country (string): Country code of the receiver (Ex: ES|DE)
      # @param receiver_in_eu (boolean): The receiver residence is in Europe?
      # @param invoice_serial: Invoices serial number
      # @param invoice_number: Invoices number
      # @param invoice_date: Invoices emission date (Format: d-m-Y)
      # @param simplified_invoice (boolean): is a simplified invoice?
      # @param invoice_description: Invoices description text
      # @param invoice_total: Total invoice amount
      # @param invoice_vat_key: Key of the VAT regime
      # @param invoice_amount: Taxable base of the invoice
      # @param invoice_vat (float): Invoice VAT (Ex: 21.0)
      # @param invoice_vat_total: Invoices number
      ###
      def initialize(**args)
        @receiver_nif = args[:receiver_nif].strip
        @receiver_name = args[:receiver_name]
        @receiver_country = args[:receiver_country]&.upcase.presence || 'ES'
        @receiver_in_eu = args[:receiver_in_eu]
        @invoice_serial = args[:invoice_serial]
        @invoice_number = args[:invoice_number]
        @invoice_date = args[:invoice_date]
        @simplified_invoice = args[:simplified_invoice]
        @invoice_description = args[:invoice_description]
        @invoice_total = args[:invoice_total]
        @invoice_vat_key = args[:invoice_vat_key]
        @invoice_amount = args[:invoice_amount]
        @invoice_vat = args[:invoice_vat]
        @invoice_vat_total = args[:invoice_vat_total]
      end

      def create
        build_document
      end

      def build_document
        if @receiver_nif.present? && @receiver_name.present?
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

        Ticketbai::Documents::IssuanceUnsigned.new(
          receiver: @receiver,
          invoice_header: @invoice_header,
          invoice_data: @invoice_data,
          breakdown_type: @breakdown_type
        ).create
      end
    end
  end
end
