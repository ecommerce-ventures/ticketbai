RSpec.describe Ticketbai::Nodes::Software do
  describe '#build_xml' do
    it 'should build the software node' do
      # Act
      node_doc = node_doc_builder

      # Assert
      expect(node_doc.delete!(" \t\r\n")).to eql('
        <?xml version="1.0" encoding="UTF-8"?>
        <Software>
          <LicenciaTBAI>XXXXXXX</LicenciaTBAI>
          <EntidadDesarrolladora>
            <NIF>B99999992</NIF>
          </EntidadDesarrolladora>
          <Nombre>FooBar SL</Nombre>
          <Version>1.0</Version>
        </Software>
      '.delete!(" \t\r\n"))
    end
  end

  private

  def node_doc_builder
    node = Ticketbai::Nodes::Software.new
    Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
      node.build_xml(xml)
    end.to_xml
  end
end
