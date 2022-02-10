require 'ticketbai/support/ticketbai_stubs'

RSpec.describe 'Api::Request' do
  describe '#initialize' do
    it 'raise ArgumentError exception with an unsupported operation param' do
      issued_invoice = File.read(File.join(__dir__, '../support/issuance-signed.xml'))

      expect { Ticketbai::Api::Request.new(
        issued_invoices: issued_invoice,
        nif: 'B45454544',
        company_name: 'test',
        certificate_name: 'test',
        year: '2022',
        operation: :unsupported_operation
      ) }.to raise_error(ArgumentError)
    end
  end

  describe '#execute' do
    it 'OK with valid issued invoice' do
      register_api_correct_stub

      issued_invoice = File.read(File.join(__dir__, '../support/issuance-signed.xml'))

      response = Ticketbai::Api::Request.new(
        issued_invoices: issued_invoice,
        nif: 'B45454544',
        company_name: 'test',
        certificate_name: 'test',
        year: '2022',
        operation: :issuance
      ).execute

      expect(response[:status]).to be Ticketbai::Api::Client::OK_RESPONSE
    end

    it 'KO with invalid issued invoice' do
      register_api_incorrect_stub

      invalid_invoice = File.read(File.join(__dir__, '../support/issuance-invalid.xml'))

      response = Ticketbai::Api::Request.new(
        issued_invoices: invalid_invoice,
        nif: 'B45454544',
        company_name: 'test',
        certificate_name: 'test',
        year: '2022',
        operation: :issuance
      ).execute

      expect(response[:status]).to be Ticketbai::Api::Client::KO_RESPONSE
      expect(response).to include(:identifier)
      expect(response[:message]).to include "Todos los registros incluidos en la petición son incorrectos."
      expect(response[:registries].size).to eq 1
      registry = response[:registries][0]
      expect(registry).to include(:number, :uploaded, :error_code, :error_message)
      expect(registry[:uploaded]).to be false
    end

    it 'PARTIALLY OK with one invoice being invalid' do
      register_api_partially_correct_stub

      issued_invoice = File.read(File.join(__dir__, '../support/issuance-signed.xml'))
      invalid_invoice = File.read(File.join(__dir__, '../support/issuance-invalid.xml'))

      response = Ticketbai::Api::Request.new(
        issued_invoices: [invalid_invoice, issued_invoice],
        nif: 'B45454544',
        company_name: 'test',
        certificate_name: 'test',
        year: '2022',
        operation: :issuance
      ).execute

      expect(response[:status]).to be Ticketbai::Api::Client::PARTIALLY_OK_RESPONSE
      expect(response).to include(:identifier)
      expect(response[:message]).to include "ParcialmenteCorrecto"
      expect(response[:registries].size).to eq 2
      invalid_registry = response[:registries][0]
      expect(invalid_registry).to include(:number, :uploaded, :error_code, :error_message)
      expect(invalid_registry[:uploaded]).to be false
      valid_registry = response[:registries][1]
      expect(valid_registry).to include(:number, :uploaded, :error_code, :error_message)
      expect(valid_registry[:uploaded]).to be true
    end
  end
end
