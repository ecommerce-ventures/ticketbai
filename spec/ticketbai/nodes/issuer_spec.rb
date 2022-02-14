RSpec.describe Ticketbai::Nodes::Issuer do
  describe '#build_xml' do
    let(:params) do
      {
        issuing_company_nif: 'B12345456',
        issuing_company_name: 'FooBar SL'
      }
    end

    it 'should build the issuer node' do
      # Act
      node_doc = node_doc_builder(params)

      # Assert
      expect(node_doc.delete!(" \t\r\n")).to eql('
        <?xml version="1.0" encoding="UTF-8"?>
        <Emisor>
          <NIF>B12345456</NIF>
          <ApellidosNombreRazonSocial>FooBar SL</ApellidosNombreRazonSocial>
        </Emisor>
      '.delete!(" \t\r\n"))
    end
  end

  private

  def node_doc_builder(params)
    node = issuer_node(params)
    Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
      node.build_xml(xml)
    end.to_xml
  end
end
