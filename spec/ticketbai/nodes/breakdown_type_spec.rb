RSpec.describe Ticketbai::Nodes::BreakdownType do
  let(:params) do
    {
      invoice_amount: 11.0,
      invoice_vat: 21.0,
      invoice_vat_total: 2.31
    }
  end
  describe '#build_xml' do
    describe 'Ordinary invoice with ES receiver country' do
      it 'should be not exempt and broken down by invoice' do
        # Arrange
        params.merge!(receiver_country: 'ES', receiver_in_eu: true, simplified_invoice: false)

        # Act
        node_doc = node_doc_builder(params)

        # Assert
        expect(node_doc.delete!(" \t\r\n")).to eql('
          <?xml version="1.0" encoding="UTF-8"?>
          <TipoDesglose>
            <DesgloseFactura>
              <Sujeta>
                <NoExenta>
                  <DetalleNoExenta>
                    <TipoNoExenta>S1</TipoNoExenta>
                    <DesgloseIVA>
                      <DetalleIVA>
                        <BaseImponible>11.0</BaseImponible>
                        <TipoImpositivo>21.0</TipoImpositivo>
                        <CuotaImpuesto>2.31</CuotaImpuesto>
                      </DetalleIVA>
                    </DesgloseIVA>
                  </DetalleNoExenta>
                </NoExenta>
              </Sujeta>
            </DesgloseFactura>
          </TipoDesglose>
        '.delete!(" \t\r\n"))
      end
    end

    describe 'Ordinary invoice with EU receiver country' do
      it 'should be exempt, reason for exemption E6 and broken down by operation type' do
        # Arrange
        params.merge!(receiver_country: 'FR', receiver_in_eu: true, simplified_invoice: false)

        # Act
        node_doc = node_doc_builder(params)

        # Assert
        expect(node_doc.delete!(" \t\r\n")).to eql('
          <?xml version="1.0" encoding="UTF-8"?>
          <TipoDesglose>
            <DesgloseTipoOperacion>
              <PrestacionServicios>
                <Sujeta>
                  <Exenta>
                    <DetalleExenta>
                      <CausaExencion>E6</CausaExencion>
                      <BaseImponible>11.0</BaseImponible>
                    </DetalleExenta>
                  </Exenta>
                </Sujeta>
              </PrestacionServicios>
            </DesgloseTipoOperacion>
          </TipoDesglose>
        '.delete!(" \t\r\n"))
      end
    end

    describe 'Ordinary invoice with non EU receiver country' do
      it 'should be exempt, reason for exemption E2 and broken down by operation type' do
        # Arrange
        params.merge!(receiver_country: 'NZ', receiver_in_eu: false, simplified_invoice: false)

        # Act
        node_doc = node_doc_builder(params)

        # Assert
        expect(node_doc.delete!(" \t\r\n")).to eql('
          <?xml version="1.0" encoding="UTF-8"?>
          <TipoDesglose>
            <DesgloseTipoOperacion>
              <PrestacionServicios>
                <Sujeta>
                  <Exenta>
                    <DetalleExenta>
                      <CausaExencion>E2</CausaExencion>
                      <BaseImponible>11.0</BaseImponible>
                    </DetalleExenta>
                  </Exenta>
                </Sujeta>
              </PrestacionServicios>
            </DesgloseTipoOperacion>
          </TipoDesglose>
        '.delete!(" \t\r\n"))
      end
    end
  end

  private

  def node_doc_builder(params)
    breakdown_type = breakdown_type_node(params)
    Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
      breakdown_type.build_xml(xml)
    end.to_xml
  end
end
