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
TODO

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ecommerce-ventures/ticketbai.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
