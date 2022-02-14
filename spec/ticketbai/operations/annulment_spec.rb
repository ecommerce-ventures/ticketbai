RSpec.describe Ticketbai::Operations::Annulment do
  describe '#create' do
    let(:annulment) do
      described_class.new(
        issuing_company_nif: 'B12345678',
        issuing_company_name: 'Test SL',
        invoice_serial: '2021',
        invoice_number: '000002',
        invoice_date: '10-11-2022',
        company_cert: :test
      ).create
    end

    it 'has xml_doc and signature_value keys' do
       expect(annulment).to include(:xml_doc, :signature_value)
    end

    it 'returns a signature value 100 characters long' do
      expect(annulment[:signature_value].length).to be 100
    end

    it 'returns a valid xml document' do
      expect(Nokogiri::XML(annulment[:xml_doc]).errors.count).to be 0
    end
  end
end
