RSpec.describe 'TbaiQr' do
  it '.create' do
    # Arrange
    id_tbai = 'TBAI-00000006Y-251019-btFpwP8dcLGAF-237'
    number = '27174'
    total = '4.70'
    serial = 'T'

    # Act
    response = Ticketbai::TbaiQr.new(id_tbai: id_tbai, number: number, total: total, serial: serial).create

    # Assert
    expect(response).to eq 'https://batuz.eus/QRTBAI/?id=TBAI-00000006Y-251019-btFpwP8dcLGAF-237&s=T&nf=27174&i=4.70&cr=007'
  end
end
