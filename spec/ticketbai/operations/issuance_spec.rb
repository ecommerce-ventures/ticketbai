RSpec.describe 'Operations::Issuance' do
  describe '#create' do
    let(:issuance) do
      Ticketbai::Operations::Issuance.new(
        issuing_company_nif: 'B12345678',
        issuing_company_name: 'Test SL',
        receiver_nif: 'B87654321',
        receiver_name: 'Foo SL',
        receiver_country: 'ES',
        receiver_in_eu: true,
        invoice_serial: '2021',
        invoice_number: '000002',
        invoice_date: '10-11-2022',
        invoice_time: '13:15:22',
        simplified_invoice: false,
        invoice_description: 'invoice description text',
        invoice_total: '150.30',
        invoice_vat_key: '01',
        invoice_amount: '130.10',
        invoice_vat: '21.0',
        invoice_vat_total: '25.11',
        prev_invoice_number: '000001',
        prev_invoice_signature: 'ad33rf244g4g4',
        prev_invoice_date: '01-01-2022',
        company_cert: :test
      ).create
    end

    it 'has xml_doc and signature_value keys' do
       expect(issuance).to include(:xml_doc, :signature_value)
    end

    it 'returns a signature value 100 characters long' do
      expect(issuance[:signature_value].length).to be 100
    end

    it 'returns a valid xml document' do
      expect(Nokogiri::XML(issuance[:xml_doc]).errors.count).to be 0
    end
  end
end
