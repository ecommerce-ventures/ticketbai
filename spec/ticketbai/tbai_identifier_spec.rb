RSpec.describe 'TbaiIdentifier' do
  it '.create' do
    # Arrange
    nif = '00000006Y'
    invoice_date = '251019'
    signature_value = 'btFpwP8dcLGAF'

    # Act
    response = Ticketbai::TbaiIdentifier.new(nif: nif, invoice_date: invoice_date, signature_value: signature_value).create

    # Assert
    expect(response).to eq 'TBAI-00000006Y-251019-btFpwP8dcLGAF-237'
  end
end