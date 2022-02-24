RSpec.describe Ticketbai::Documents::Annulment do
  include_context('with document')

  describe '#create' do
    it 'creates a valid document' do
      document = described_class.new(
        issuer: issuer_node(issuer_params),
        invoice_header: invoice_header_node(invoice_header_params),
        software: Ticketbai::Nodes::Software.new
      ).create.to_xml

      expect(document).to include('<T:AnulaTicketBai xmlns:T="urn:ticketbai:anulacion">')
      expect(document).to include('<Emisor>')
      expect(document).to include('<CabeceraFactura>')
      expect(document).to include('<Software>')
    end
  end
end
