
RSpec.describe 'Documents::Issuance#create' do
  # One of these receiver countries should be merged into receiver_params and breakdown_type_params when building related nodes
  let(:receiver_spain) { { receiver_country: 'ES' } }
  let(:receiver_eu) { { receiver_country: 'IT' } }
  let(:receiver_non_eu) { { receiver_country: 'NZ' } }

  # For simplified invoices this should be merged into invoice_header_params and breakdown_type_params when building related nodes
  let(:simplified_invoice) { { simplified_invoice: true } }

  let(:issuer_params) do
    {
      issuing_company_nif: 'B12345456',
      issuing_company_name: 'FooBar SL'
    }
  end

  let(:receiver_params) do
    {
      receiver_nif: 'B55434567',
      receiver_name: 'ACME SL'
    }
  end

  let(:invoice_header_params) do
    {
      invoice_serial: 'GH',
      invoice_number: '20211143',
      invoice_date: '10-12-2021',
      invoice_time: '14:05:20',
      simplified_invoice: false
    }
  end

  let(:invoice_data_params) do
    {
      invoice_description: 'Una maravillosa descripción de la factura',
      invoice_total: 12.21,
      invoice_vat_key: '01'
    }
  end

  let(:breakdown_type_params) do
    {
      invoice_amount: 11.0,
      invoice_vat: 21.0,
      invoice_vat_total: 2.31,
      receiver_in_eu: true,
      simplified_invoice: false
    }
  end

  describe 'With an ordinary invoice' do
    it 'should create a valid document with ES receiver country' do
      # Act
      document = build_document(
        issuer: issuer_node(issuer_params),
        receiver: receiver_node(receiver_params.merge!(receiver_spain)),
        invoice_header: invoice_header_node(invoice_header_params),
        invoice_data: invoice_data_node(invoice_data_params),
        breakdown_type: breakdown_type_node(breakdown_type_params.merge!(receiver_spain))
      )

      # Assert
      expect(document).to include('<T:TicketBai xmlns:T="urn:ticketbai:emision">')
      expect(document).to include('<IDDestinatario>')
      expect(document).not_to include('<FacturaSimplificada>S</FacturaSimplificada>')
      expect(document).to include('<DesgloseFactura>')
      expect(document).not_to include('<EncadenamientoFacturaAnterior>')
    end

    it 'should create a valid document with EU receiver country' do
      # Act
      document = build_document(
        issuer: issuer_node(issuer_params),
        receiver: receiver_node(receiver_params.merge!(receiver_eu)),
        invoice_header: invoice_header_node(invoice_header_params),
        invoice_data: invoice_data_node(invoice_data_params),
        breakdown_type: breakdown_type_node(breakdown_type_params.merge!(receiver_eu))
      )

      # Assert
      expect(document).to include('<T:TicketBai xmlns:T="urn:ticketbai:emision">')
      expect(document).to include('IDDestinatario')
      expect(document).not_to include('<FacturaSimplificada>S</FacturaSimplificada>')
      expect(document).to include('DesgloseTipoOperacion')
      expect(document).to include('<Exenta>')
      expect(document).to include('<CausaExencion>E6</CausaExencion>')
      expect(document).not_to include('<EncadenamientoFacturaAnterior>')
    end

    it 'should create a valid document with non EU receiver country' do
      # Act
      document = build_document(
        issuer: issuer_node(issuer_params),
        receiver: receiver_node(receiver_params.merge!(receiver_non_eu)),
        invoice_header: invoice_header_node(invoice_header_params),
        invoice_data: invoice_data_node(invoice_data_params),
        breakdown_type: breakdown_type_node(breakdown_type_params.merge!(receiver_non_eu).merge!(receiver_in_eu: false))
      )

      # Assert
      expect(document).to include('<T:TicketBai xmlns:T="urn:ticketbai:emision">')
      expect(document).to include('<IDDestinatario>')
      expect(document).not_to include('<FacturaSimplificada>S</FacturaSimplificada>')
      expect(document).to include('<DesgloseTipoOperacion>')
      expect(document).to include('<Exenta>')
      expect(document).to include('<CausaExencion>E2</CausaExencion>')
      expect(document).not_to include('<EncadenamientoFacturaAnterior>')
    end
  end

  describe 'With a simplified invoice' do
    it 'should create a valid document with ES receiver country' do
      # Act
      document = build_document(
        issuer: issuer_node(issuer_params),
        invoice_header: invoice_header_node(invoice_header_params.merge!(simplified_invoice)),
        invoice_data: invoice_data_node(invoice_data_params),
        breakdown_type: breakdown_type_node(breakdown_type_params.merge!(simplified_invoice).merge!(receiver_spain))
      )

      # Assert
      expect(document).to include('<T:TicketBai xmlns:T="urn:ticketbai:emision">')
      expect(document).not_to include('<IDDestinatario>')
      expect(document).to include('<FacturaSimplificada>S</FacturaSimplificada>')
      expect(document).to include('<DesgloseFactura>')
      expect(document).to include('<NoExenta>')
      expect(document).not_to include('<CausaExencion>')
      expect(document).not_to include('<EncadenamientoFacturaAnterior>')
    end

    it 'should create a valid document with EU receiver country' do
      # Act
      document = build_document(
        issuer: issuer_node(issuer_params),
        invoice_header: invoice_header_node(invoice_header_params.merge!(simplified_invoice)),
        invoice_data: invoice_data_node(invoice_data_params),
        breakdown_type: breakdown_type_node(breakdown_type_params.merge!(receiver_eu).merge!(simplified_invoice))
      )

      # Assert
      expect(document).to include('<T:TicketBai xmlns:T="urn:ticketbai:emision">')
      expect(document).not_to include('<IDDestinatario>')
      expect(document).to include('<FacturaSimplificada>S</FacturaSimplificada>')
      expect(document).to include('<DesgloseFactura>')
      expect(document).to include('<Exenta>')
      expect(document).to include('<CausaExencion>E6</CausaExencion>')
      expect(document).not_to include('<EncadenamientoFacturaAnterior>')
    end
  end
end
