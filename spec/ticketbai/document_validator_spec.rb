RSpec.describe Ticketbai::DocumentValidator do
  include_context('with document')

  describe '#initialize' do
    it 'should raise ArgumentError exception with a non supported validator type' do
      # Assert
      expect { described_class.new(document: document, validator_type: :unsupported).validate }.to raise_error(ArgumentError)
    end
  end

  describe '#validate' do
    it 'should not raise any error if the document is valid' do
      # Act
      signed_doc = sign_doc(document)

      # Assert
      described_class.new(document: signed_doc, validator_type: :issuance).validate
    end

    it 'should raise error if some field of the document is not valid' do
      # Act
      document = build_document(
        issuer: issuer_node(issuing_company_nif: 'B123454568989', issuing_company_name: 'FooBar SL'),
        receiver: receiver_node(receiver_params.merge!(receiver_spain)),
        invoice_header: invoice_header_node(invoice_header_params),
        invoice_data: invoice_data_node(invoice_data_params),
        breakdown_type: breakdown_type_node(breakdown_type_params.merge!(receiver_spain))
      )
      signed_doc = sign_doc(document)

      # Assert
      validator = described_class.new(document: signed_doc, validator_type: :issuance)
      expect { validator.validate }.to raise_error(Ticketbai::TBAIFileError)
    end
  end
end
