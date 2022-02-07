RSpec.describe 'InvoiceData#build_xml' do
  let(:params) do
    {
      invoice_description: 'Descripción de la factura',
      invoice_total: 215.0,
      invoice_vat_key: '01'
    }
  end

  it 'should build the invoice data' do
    # Act
    node_doc = node_doc_builder(params)

    # Assert
    expect(node_doc.delete!(" \t\r\n")).to eql('
      <?xml version="1.0" encoding="UTF-8"?>
      <DatosFactura>
        <DescripcionFactura>Descripción de la factura</DescripcionFactura>
        <ImporteTotalFactura>215.0</ImporteTotalFactura>
        <Claves>
          <IDClave>
            <ClaveRegimenIvaOpTrascendencia>01</ClaveRegimenIvaOpTrascendencia>
          </IDClave>
        </Claves>
      </DatosFactura>
    '.delete!(" \t\r\n"))
  end

  private

  def node_doc_builder(params)
    node = invoice_data_node(params)
    Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
      node.build_xml(xml)
    end.to_xml
  end
end
