RSpec.describe Ticketbai::Nodes::LroeIssuedInvoices do
  describe '#build_xml' do
    let(:annulment_xml) { File.read(File.join(__dir__, '/../support/annulment-signed.xml')) }
    let(:issuance_xml) { File.read(File.join(__dir__, '/../support/issuance-signed.xml')) }
    let(:issuance_unsigned_doc) { File.read(File.join(__dir__, '/../support/issuance-unsigned.txt')) }
    let(:annulment_node) {
      Ticketbai::Nodes::LroeIssuedInvoices.new(
        operation: Ticketbai::Operations::Annulment::OPERATION_NAME,
        issued_invoices: [Nokogiri::XML(annulment_xml).to_xml]
      )
    }
    let(:issuance_node) {
      Ticketbai::Nodes::LroeIssuedInvoices.new(
        operation: Ticketbai::Operations::Issuance::OPERATION_NAME,
        issued_invoices: [Nokogiri::XML(issuance_xml).to_xml]
      )
    }
    let(:issuance_unsigned_node) {
      Ticketbai::Nodes::LroeIssuedInvoices.new(
        operation: Ticketbai::Operations::IssuanceUnsigned::OPERATION_NAME,
        issued_invoices: [issuance_unsigned_doc]
      )
    }

    it 'should build the node for annulment invoices' do
      node_doc = node_doc_builder(annulment_node)
      expect(node_doc).to include('<AnulacionTicketBai>')
    end

    it 'should build the node for issuance invoices' do
      node_doc = node_doc_builder(issuance_node)
      expect(node_doc).to include('<TicketBai>')
    end

    it 'should build the node for issuance unsigned invoices' do
      node_doc = node_doc_builder(issuance_unsigned_node)
      expect(node_doc).not_to include('<TicketBai>')
      expect(node_doc).not_to include('<AnulacionTicketBai>')
    end
  end

  private

  def node_doc_builder(node)
    Nokogiri::XML::Builder.new(encoding: Encoding::UTF_8.to_s) do |xml|
      node.build_xml(xml)
    end.to_xml
  end
end
