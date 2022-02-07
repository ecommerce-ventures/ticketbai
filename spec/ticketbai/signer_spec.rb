RSpec.describe 'Signer' do
  include_context('with document')

  it '.sign' do
    signed_doc = sign_doc(document)
  end
end
