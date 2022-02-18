RSpec.describe Ticketbai::Nodes::LroeHeader do
  describe '#build_xml' do
    let(:lroe_header) {
      Ticketbai::Nodes::LroeHeader.new(
        year: '2022',
        nif: 'B89098785',
        company_name: 'Foo SL',
        operation: Ticketbai::Operations::Issuance::OPERATION_NAME,
        subchapter: '1.1'
      )
    }
    it 'should build the LROE header node' do
      expect(node_doc_builder(lroe_header).delete!(" \t\r\n")).to eql('
        <?xml version="1.0" encoding="UTF-8"?>
        <Cabecera>
          <Modelo>240</Modelo>
          <Capitulo>1</Capitulo>
          <Subcapitulo>1.1</Subcapitulo>
          <Operacion>issuance</Operacion>
          <Version>1.0</Version>
          <Ejercicio>2022</Ejercicio>
          <ObligadoTributario>
            <NIF>B89098785</NIF>
            <ApellidosNombreRazonSocial>Foo SL</ApellidosNombreRazonSocial>
          </ObligadoTributario>
        </Cabecera>
      '.delete!(" \t\r\n"))
    end
  end

  private

  def node_doc_builder(node)
    Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
      node.build_xml(xml)
    end.to_xml
  end
end
