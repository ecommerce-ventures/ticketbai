module Ticketbai
  class Operation
    ###
    # Creates the Ticketbai operation by doing the following:
    # 1. Build the document
    # 2. Sign the document
    # 3. Validate the signed document
    #
    # @return [Hash] xml_doc: The signed document. signature_value: The first 100 characters of the signature value
    ###
    def create
      document = build_document

      signed_document = sign_document(document)

      validate_document(signed_document)

      signature_value = read_signature_value(signed_document)[0..99]

      { xml_doc: signed_document, signature_value: signature_value }
    end

    def build_document
      raise NotImplementedError, 'Must implement this method'
    end

    private

    def modify_xml_root_name(builder)
      builder.doc.root.name = self.class::ROOT_NAME
    end

    def decoded_cert
      Base64.decode64(@company_cert[:cert])
    end

    def sign_document(document)
      Signer.new({ xml: document.to_xml, certificate: decoded_cert, key: @company_cert[:key] }).sign
    end

    def validate_document(document)
      DocumentValidator.new(document: document, validator_type: self.class::OPERATION_NAME).validate
    end

    def read_signature_value(document)
      Nokogiri::XML(document).children.last.children.last.children[1].children.first.text
    end
  end
end
