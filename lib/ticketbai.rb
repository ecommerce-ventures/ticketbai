# frozen_string_literal: true

require 'ticketbai/checksum_calculator'
require 'ticketbai/document'
require 'ticketbai/documents/issuance'
require 'ticketbai/documents/issuance_unsigned'
require 'ticketbai/documents/annulment'
require 'ticketbai/documents/api_payload'
require 'ticketbai/errors'
require 'ticketbai/nodes/issuer'
require 'ticketbai/nodes/receiver'
require 'ticketbai/nodes/invoice_header'
require 'ticketbai/nodes/invoice_data'
require 'ticketbai/nodes/breakdown_type'
require 'ticketbai/nodes/software'
require 'ticketbai/nodes/invoice_chaining'
require 'ticketbai/nodes/lroe_header'
require 'ticketbai/nodes/lroe_issued_invoices'
require 'ticketbai/operation'
require 'ticketbai/operations/annulment'
require 'ticketbai/operations/issuance'
require 'ticketbai/operations/issuance_unsigned'
require 'ticketbai/signer'
require 'ticketbai/tbai_identifier'
require 'ticketbai/tbai_qr'
require 'ticketbai/document_validator'
require 'ticketbai/api/client'
require 'ticketbai/api/registry'
require 'ticketbai/api/response_parser'
require 'ticketbai/api/request'

module Ticketbai
  Config = Struct.new(
    :license_key,
    :app_name,
    :app_version,
    :developer_company_nif,
    :certificates
  )

  class << self
    # Module configuration.
    def configure
      @config ||= Config.new
      yield(@config)
    end

    attr_reader :config

    def mode
      if instance_variable_defined? :@mode
        instance_variable_get :@mode
      else
        :test
      end
    end

    def mode=(mode)
      mode = mode&.to_sym
      raise "Invalid mode #{mode}" unless %i[live test].include?(mode)

      instance_variable_set :@mode, mode
    end

    def test?
      mode == :test
    end

    def live?
      mode == :live
    end

    def logger
      instance_variable_get :@logger
    end

    def logger=(logger)
      instance_variable_set :@logger, logger
    end

    def debug
      instance_variable_get(:@debug) == true
    end

    def debug=(debug)
      instance_variable_set :@debug, debug
    end
  end
end
