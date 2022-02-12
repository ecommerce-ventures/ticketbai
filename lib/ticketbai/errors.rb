module Ticketbai
  # Generic Ticketbai exception class.
  class Error < StandardError; end

  # For errors returned by the client library, like HTTP errors
  class ClientError < Error; end

  # For errors returned by the API
  class APIError < Error
    attr_reader :code

    def initialize(message = nil, code = nil)
      @code = code
      super(message)
    end
  end

  # For errors returned by the TBAIFile validation.
  class TBAIFileError < Error
    attr_reader :code

    def initialize(message = nil, code = nil)
      @code = code
      super(message)
    end
  end
end
