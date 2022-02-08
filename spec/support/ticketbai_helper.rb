RSpec.shared_context("with document") do
  # One of these receiver countries should be merged into receiver_params and breakdown_type_params when building related nodes
  let(:receiver_spain) { { receiver_country: 'ES' } }
  let(:receiver_eu) { { receiver_country: 'IT' } }
  let(:receiver_non_eu) { { receiver_country: 'NZ' } }

  # For simplified invoices this should be merged into invoice_header_params and breakdown_type_params when building related nodes
  let(:simplified_invoice) { { simplified_invoice: true } }

  let(:issuer_params) do
    {
      issuing_company_nif: 'B12345456',
      issuing_company_name: 'FooBar SL'
    }
  end

  let(:receiver_params) do
    {
      receiver_nif: 'B55434567',
      receiver_name: 'ACME SL'
    }
  end

  let(:invoice_header_params) do
    {
      invoice_serial: 'GH',
      invoice_number: '20211143',
      invoice_date: '10-12-2021',
      invoice_time: '14:05:20',
      simplified_invoice: false
    }
  end

  let(:invoice_data_params) do
    {
      invoice_description: 'Una maravillosa descripción de la factura',
      invoice_total: 12.21,
      invoice_vat_key: '01'
    }
  end

  let(:breakdown_type_params) do
    {
      invoice_amount: 11.0,
      invoice_vat: 21.0,
      invoice_vat_total: 2.31,
      receiver_in_eu: true,
      simplified_invoice: false
    }
  end

  let(:document) do
    build_document(
      issuer: issuer_node(issuer_params),
      receiver: receiver_node(receiver_params.merge!(receiver_spain)),
      invoice_header: invoice_header_node(invoice_header_params),
      invoice_data: invoice_data_node(invoice_data_params),
      breakdown_type: breakdown_type_node(breakdown_type_params.merge!(receiver_spain))
    )
  end
end

def issuer_node(params)
  Ticketbai::Nodes::Issuer.new(params)
end

def receiver_node(params)
  Ticketbai::Nodes::Receiver.new(params)
end

def invoice_header_node(params)
  Ticketbai::Nodes::InvoiceHeader.new(params)
end

def invoice_data_node(params)
  Ticketbai::Nodes::InvoiceData.new(params)
end

def breakdown_type_node(params)
  Ticketbai::Nodes::BreakdownType.new(params)
end

def build_document(issuer:, invoice_header:, invoice_data:, breakdown_type:, receiver: nil)
  software = Ticketbai::Nodes::Software.new

  Ticketbai::Documents::Issuance.new(
    issuer: issuer,
    receiver: receiver,
    invoice_header: invoice_header,
    invoice_data: invoice_data,
    breakdown_type: breakdown_type,
    software: software
  ).create.to_xml
end

def sign_doc(document)
  cert = Ticketbai.config.certificates[:test][:cert]
  key = Ticketbai.config.certificates[:test][:key]

  Ticketbai::Signer.new({ xml: document, certificate: Base64.decode64(cert), key: key }).sign
end
