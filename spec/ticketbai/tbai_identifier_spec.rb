RSpec.describe Ticketbai::TbaiIdentifier do
  describe '#create' do
    it 'should return a valid Tbai identifier' do
      expect(
        described_class.new(
          nif: '00000006Y',
          invoice_date: '251019',
          signature_value: 'btFpwP8dcLGAF'
        ).create
      ).to eq 'TBAI-00000006Y-251019-btFpwP8dcLGAF-237'
    end
  end
end
