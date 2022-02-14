RSpec.describe Ticketbai::Nodes::InvoiceHeader do
  describe '#build_xml' do
    let(:params) do
      {
        invoice_serial: 'GH',
        invoice_number: '20211143',
        invoice_date: '10-12-2021',
        invoice_time: '14:05:20',
        simplified_invoice: false
      }
    end

    it 'should build the ordinary invoice header node' do
      # Act
      node_doc = node_doc_builder(params)

      # Assert
      expect(node_doc.delete!(" \t\r\n")).to eql('
        <?xml version="1.0" encoding="UTF-8"?>
        <CabeceraFactura>
          <SerieFactura>GH</SerieFactura>
          <NumFactura>20211143</NumFactura>
          <FechaExpedicionFactura>10-12-2021</FechaExpedicionFactura>
          <HoraExpedicionFactura>14:05:20</HoraExpedicionFactura>
        </CabeceraFactura>
      '.delete!(" \t\r\n"))
    end

    it 'should build the simplified invoice header node' do
      # Act
      params[:simplified_invoice] = true
      node_doc = node_doc_builder(params)

      # Assert
      expect(node_doc.delete!(" \t\r\n")).to eql('
        <?xml version="1.0" encoding="UTF-8"?>
        <CabeceraFactura>
          <SerieFactura>GH</SerieFactura>
          <NumFactura>20211143</NumFactura>
          <FechaExpedicionFactura>10-12-2021</FechaExpedicionFactura>
          <HoraExpedicionFactura>14:05:20</HoraExpedicionFactura>
          <FacturaSimplificada>S</FacturaSimplificada>
        </CabeceraFactura>
      '.delete!(" \t\r\n"))
    end
  end

  private

  def node_doc_builder(params)
    node = invoice_header_node(params)
    Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
      node.build_xml(xml)
    end.to_xml
  end
end
