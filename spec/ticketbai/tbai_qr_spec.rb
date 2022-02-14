RSpec.describe Ticketbai::TbaiQr do
  describe '#create' do
    it 'should return a valid Tbai QR url' do
      expect(
        described_class.new(
          id_tbai: 'TBAI-00000006Y-251019-btFpwP8dcLGAF-237',
          number: '27174',
          total: '4.70',
          serial: 'T'
        ).create
      ).to eq 'https://batuz.eus/QRTBAI/?id=TBAI-00000006Y-251019-btFpwP8dcLGAF-237&s=T&nf=27174&i=4.70&cr=007'
    end
  end
end
