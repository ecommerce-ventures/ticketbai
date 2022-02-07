module Ticketbai
  class DocumentValidator
    attr_accessor :document, :validator_type

    SUPPORTED_VALIDATORS = [Operations::Issuance::OPERATION_NAME, Operations::Annulment::OPERATION_NAME].freeze

    ###
    # @param [String] document The xml document to be validated
    # @param [String] validator_type The validator name to be used to validate the document (.xsd file)
    ###
    def initialize(document:, validator_type:)
      raise ArgumentError, 'Unsupported validator' unless SUPPORTED_VALIDATORS.include? validator_type.downcase.to_sym

      @document = document
      @validator_type = validator_type.downcase.to_sym
    end

    ###
    # Raises an exception with the validation error(s)
    ###
    def validate
      errors = []

      xsd_validator.validate(Nokogiri::XML(@document)).each do |error|
        errors << error.message
      end

      return unless errors.any?

      raise Ticketbai::TBAIFileError.new(
        errors.uniq.join(','),
        'TBAIFile'
      )
    end

    private

    def xsd_validator
      Nokogiri::XML::Schema(File.read("#{__dir__}/xsd_validators/#{@validator_type}.xsd"))
    end
  end
end
