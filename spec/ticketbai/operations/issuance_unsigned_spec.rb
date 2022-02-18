RSpec.describe Ticketbai::Operations::IssuanceUnsigned do
  describe '#create' do
    let(:issuance_unsigned) do
      described_class.new(
        receiver_nif: 'B87654321',
        receiver_name: 'Foo SL',
        receiver_country: 'ES',
        receiver_in_eu: true,
        invoice_serial: '2021',
        invoice_number: '000002',
        invoice_date: '10-11-2022',
        simplified_invoice: false,
        invoice_description: 'invoice description text',
        invoice_total: '150.30',
        invoice_vat_key: '01',
        invoice_amount: '130.10',
        invoice_vat: '21.0',
        invoice_vat_total: '25.11'
      ).create
    end
    it 'returns the document string' do
      fa = Nokogiri::XML::DocumentFragment.parse('
        <Destinatarios>
          <IDDestinatario>
            <NIF>B87654321</NIF>
            <ApellidosNombreRazonSocial>Foo SL</ApellidosNombreRazonSocial>
          </IDDestinatario>
        </Destinatarios>
        <CabeceraFactura>
          <SerieFactura>2021</SerieFactura>
          <NumFactura>000002</NumFactura>
          <FechaExpedicionFactura>10-11-2022</FechaExpedicionFactura>
        </CabeceraFactura>
        <DatosFactura>
          <DescripcionFactura>invoice description text</DescripcionFactura>
          <ImporteTotalFactura>150.30</ImporteTotalFactura>
          <Claves>
            <IDClave>
              <ClaveRegimenIvaOpTrascendencia>01</ClaveRegimenIvaOpTrascendencia>
            </IDClave>
          </Claves>
        </DatosFactura>
        <TipoDesglose>
          <DesgloseFactura>
            <Sujeta>
              <NoExenta>
                <DetalleNoExenta>
                  <TipoNoExenta>S1</TipoNoExenta>
                  <DesgloseIVA>
                    <DetalleIVA>
                      <BaseImponible>130.10</BaseImponible>
                      <TipoImpositivo>21.0</TipoImpositivo>
                      <CuotaImpuesto>25.11</CuotaImpuesto>
                    </DetalleIVA>
                  </DesgloseIVA>
                </DetalleNoExenta>
              </NoExenta>
            </Sujeta>
          </DesgloseFactura>
        </TipoDesglose>
      ')
      fr = Nokogiri::XML::DocumentFragment.parse(issuance_unsigned)

      expect(fa.to_xml.split.join(' ')).to eql(fr.to_xml.split.join(' '))
    end
  end
end
