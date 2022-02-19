
RSpec.describe Ticketbai::Documents::Issuance do
  include_context('with document')

  describe '#create' do
    describe 'With an ordinary invoice' do
      it 'should create a valid document with ES receiver country' do
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
        expect(document).to include('<IDDestinatario>')
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
end
