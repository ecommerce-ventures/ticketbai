RSpec.describe 'Api::Request.execute' do
  include_context('with document')

  it 'should execute a request' do
    signed_doc = sign_doc(document)

    Ticketbai::Api::Request.new(
      issued_invoices: signed_doc,
      nif: 'B45454544',
      company_name: 'test',
      certificate_name: 'test',
      year: '2022',
      operation: :issuance
    ).execute
  end
end
