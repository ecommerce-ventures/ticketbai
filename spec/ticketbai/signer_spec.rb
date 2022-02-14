RSpec.describe Ticketbai::Signer do
  include_context('with document')

  describe '#initialize' do
    it 'raise ArgumentError exception if any param is nil' do
      cert = Ticketbai.config.certificates[:test][:cert]
      key = Ticketbai.config.certificates[:test][:key]

      expect do
        described_class.new(xml: document, certificate: Base64.decode64(cert))
      end.to raise_error(ArgumentError)
    end
  end

  describe '#sign' do
    it 'should sign a document' do
      signed_doc = sign_doc(document)
    end
  end
end
