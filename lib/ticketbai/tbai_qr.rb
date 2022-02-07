module Ticketbai
  class TbaiQr
    BASE_URL = 'https://batuz.eus/QRTBAI/?'.freeze

    # param names
    ID_TBAI_NAME = 'id'.freeze
    SERIAL_NAME = 's'.freeze
    NUMBER_NAME = 'nf'.freeze
    TOTAL_NAME = 'i'.freeze
    CRC_NAME = 'cr'.freeze

    attr_accessor :id_tbai, :number, :serial, :total

    ###
    # @param [String] id_tbai The Tbai Identifier
    # @param [String] number Invoice number
    # @param [String] total Invoice total amount (Max 2 decimals) Ex: 14.20
    # @param [String] serial The invoice serial number
    ###
    def initialize(**args)
      self.id_tbai = args[:id_tbai]
      self.serial = args[:serial]
      self.number = args[:number]
      self.total = args[:total]
    end

    ###
    # Builds the Ticketbai QR URL. Example: https://batuz.eus/QRTBAI/?id=TBAI-00000006Y-251019-btFpwP8dcLGAF-237&s=T&nf=27174&i=4.70&cr=007
    # @return [String] Ticketbai QR URL
    ###
    def create
      encoded_params = [
        format_param(ID_TBAI_NAME, @id_tbai),
        format_param(SERIAL_NAME, @serial),
        format_param(NUMBER_NAME, @number),
        format_param(TOTAL_NAME, @total)
      ].join('&')

      crc = ChecksumCalculator.new(BASE_URL + encoded_params).calculate

      BASE_URL + [encoded_params, format_param(CRC_NAME, crc)].join('&')
    end

    private

    def format_param(name, value)
      "#{name}=#{ERB::Util.url_encode(value)}"
    end
  end
end
