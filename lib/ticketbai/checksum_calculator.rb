module Ticketbai
  class ChecksumCalculator
    attr_accessor :data

    def initialize(data)
      @data = data
    end

    def calculate
      checksum = Digest::CRC8.checksum(@data)

      format('%03d', checksum.to_s)
    end
  end
end
