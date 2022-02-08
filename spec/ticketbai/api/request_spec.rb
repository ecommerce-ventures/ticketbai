require 'ticketbai/support/ticketbai_stubs'

RSpec.describe 'Api::Request' do

  include_context('with document')

  describe '#initialize' do
    it 'raise ArgumentError exception with an unsupported operation param' do
      signed_doc = sign_doc(document)

      expect { Ticketbai::Api::Request.new(
        issued_invoices: signed_doc,
        nif: 'B45454544',
        company_name: 'test',
        certificate_name: 'test',
        year: '2022',
        operation: :unsupported_operation
      ) }.to raise_error(ArgumentError)
    end
  end

  describe '#execute' do
    it 'should return OK with one valid issued invoice' do
      register_ticketbai_stubs

      signed_doc = sign_doc(document)

      response = Ticketbai::Api::Request.new(
        issued_invoices: signed_doc,
        nif: 'B45454544',
        company_name: 'test',
        certificate_name: 'test',
        year: '2022',
        operation: :issuance
      ).execute

      expect(response[:status]).to be Ticketbai::Api::Client::OK_RESPONSE
    end
  end
end
