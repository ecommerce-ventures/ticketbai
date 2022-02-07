module Ticketbai
  class TbaiIdentifier
    ID = 'TBAI'.freeze

    attr_accessor :nif, :invoice_date, :signature_value

    ###
    # @param [String] nif The issuer NIF
    # @param [String] invoice_date Format DDMMYY
    # @param [String] signature_value First 13 characters of the signatureValue present in the signed xml
    ###
    def initialize(**args)
      self.nif = args[:nif]
      self.invoice_date = args[:invoice_date]
      self.signature_value = args[:signature_value][0..12]
    end

    ###
    # @return [String] The TBAI identifier.
    # Format: TBAI-NIF-FechaExpedicionFactura(DDMMAA)-SignatureValue(13)-CRC(3)
    ###
    def create
      identifier = [ID, @nif, @invoice_date, @signature_value].join('-')
      identifier << '-'

      crc = ChecksumCalculator.new(identifier).calculate

      identifier << crc

      identifier
    end
  end
end
