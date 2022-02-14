RSpec.describe Ticketbai::Nodes::Receiver do
  describe '#build_xml' do
    let(:params) do
      {
        receiver_nif: 'B55434567',
        receiver_name: 'ACME SL',
        receiver_country: 'ES'
      }
    end

    it 'should build the national receiver node' do
      # Act
      node_doc = node_doc_builder(params)

      # Assert
      expect(node_doc.delete!(" \t\r\n")).to eql('
        <?xml version="1.0" encoding="UTF-8"?>
        <Destinatarios>
          <IDDestinatario>
            <NIF>B55434567</NIF>
            <ApellidosNombreRazonSocial>ACME SL</ApellidosNombreRazonSocial>
          </IDDestinatario>
        </Destinatarios>
      '.delete!(" \t\r\n"))
    end

    it 'should build the foreign receiver node' do
      # Act
      params[:receiver_country] = 'FR'
      node_doc = node_doc_builder(params)

      # Assert
      expect(node_doc.delete!(" \t\r\n")).to eql('
        <?xml version="1.0" encoding="UTF-8"?>
        <Destinatarios>
          <IDDestinatario>
            <IDOtro>
              <CodigoPais>FR</CodigoPais>
              <IDType>04</IDType>
              <ID>B55434567</ID>
            </IDOtro>
            <ApellidosNombreRazonSocial>ACME SL</ApellidosNombreRazonSocial>
          </IDDestinatario>
        </Destinatarios>
      '.delete!(" \t\r\n"))
    end
  end

  private

  def node_doc_builder(params)
    node = receiver_node(params)
    Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
      node.build_xml(xml)
    end.to_xml
  end
end
