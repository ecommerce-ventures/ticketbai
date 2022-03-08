# Ticketbai

Ticketbai is a gem that gives you the ability to generate Ticketbai files and upload them to the Regional Treasury (currently only Bizkaia is supported)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ticketbai'
```
Then run:

```bash
bundle install
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ticketbai

## Configuration

Encode your certificate to be able to add the resulting string to the secrets file:

```
certificate = File.read('path/my-certificate.pfx')
encoded_certificate = Base64.strict_encode64(certificate)
```

Add the encoded_certificate string, the key and the rest of your ticketbai license params to the secrets file:

```
ticketbai:
  license_key: xxxxxxxxxx
  app_name: xxxxxxxxxx
  app_version: xxxxxxxxxx
  developer_company_nif: xxxxxxxxxx
  certificates:
    my_certificate_name:
      cert: encoded_certificate string
      key: xxxxxxxxxx
```

## Usage
The supported TicketBAI operations are: issuance, annulment and issuance unsigned.

#### Issuance operation
```
Ticketbai::Operations::Issuance.new(
  company_cert: 'my_certificate_name',
  issuing_company_nif: 'B34576372',
  issuing_company_name: 'FooBar SL',
  invoice_serial: '2022',
  invoice_number: '10001',
  invoice_date: '11-01-2022',
  invoice_time: '13:05:22',
  invoice_description: 'La descripción de la factura',
  invoice_total: 12.21,
  invoice_vat_key: '01',
  invoice_amount: 11.0,
  invoice_vat: 21.0,
  invoice_vat_total: 2.31,
  simplified_invoice: true
).create
```
If everything is ok, the response of `Ticketbai::Operations::Issuance.new(params).create` is a Hash with two keys:
- xml_doc: The signed TicketBAI XML string.
- signature_value: The first 100 characters of the signature value needed for the chaining of TicketBAI files.

#### Annulment operation
```
Ticketbai::Operations::Annulment.new(
  issuing_company_nif: 'B12345678',
  issuing_company_name: 'Test SL',
  invoice_serial: '2022',
  invoice_number: '000002',
  invoice_date: '10-11-2022',
  company_cert: 'my_certificate_name'
).create
```  

#### API Upload

Sending the TicketBAI files to the LROE is done by executing the following request to the API:
```
Ticketbai::Api::Request.new(
  issued_invoices: xml_doc,
  nif: 'B34576372',
  company_name: 'FooBar SL',
  certificate_name: 'my_certificate_name',
  year: '2022',
  operation: :issuance
).execute
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ecommerce-ventures/ticketbai.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
