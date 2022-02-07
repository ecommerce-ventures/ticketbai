require 'openssl'
require 'base64'
require "rexml/document"
require "rexml/xpath"
require 'securerandom'
require 'date'

module Ticketbai
  class Signer
    C14N            = 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315'.freeze # "http://www.w3.org/2001/10/xml-exc-c14n#"
    DSIG            = 'http://www.w3.org/2000/09/xmldsig#'.freeze
    NOKOGIRI_OPTIONS = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NONET | Nokogiri::XML::ParseOptions::NOENT
    RSA_SHA256      = 'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'.freeze
    SHA1            = 'http://www.w3.org/2000/09/xmldsig#sha1'.freeze
    SHA256          = 'http://www.w3.org/2001/04/xmlenc#sha256'.freeze
    SHA384          = 'http://www.w3.org/2001/04/xmldsig-more#sha384'.freeze
    SHA512          = 'http://www.w3.org/2001/04/xmlenc#sha512'.freeze
    ENVELOPED_SIG   = 'http://www.w3.org/2000/09/xmldsig#enveloped-signature'.freeze
    NAMESPACES      = '#default ds xs xsi xades xsd'.freeze
    XADES           = 'http://uri.etsi.org/01903/v1.3.2#'.freeze

    POLITICA_NAME       = 'Politica de firma TicketBAI 1.0'.freeze
    POLITICA_URL        = 'https://www.batuz.eus/fitxategiak/batuz/ticketbai/sinadura_elektronikoaren_zehaztapenak_especificaciones_de_la_firma_electronica_v1_0.pdf'.freeze
    POLITICA_DIGEST     = 'Quzn98x3PMbSHwbUzaj5f5KOpiH0u8bvmwbbbNkO9Es='.freeze

    def initialize(args = {})
      xml = args[:xml]
      certificate = args[:certificate]
      key = args[:key]
      @output_path = args[:output_path]

      raise ArgumentError, 'Invalid arguments' if xml.nil? || certificate.nil? || key.nil?

      @doc = Nokogiri::XML(xml) do |config|
        config.options = Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::NOENT | Nokogiri::XML::ParseOptions::NOENT
      end

      @p12 = OpenSSL::PKCS12.new(certificate, key)

      @x509 = @p12.certificate
      @document_tag = @doc.elements.first.name
    end

    def sign
      # Build parts for Digest Calculation
      key_info = build_key_info_element
      signed_properties = build_signed_properties_element
      signed_info_element = build_signed_info_element(key_info, signed_properties)

      # Compute Signature
      signed_info_canon = canonicalize_document(signed_info_element)
      signature_value = compute_signature(@p12.key, algorithm(RSA_SHA256).new, signed_info_canon)

      ds = Nokogiri::XML::Node.new('ds:Signature', @doc)

      ds['xmlns:ds'] = DSIG
      ds['Id'] = "xmldsig-#{uuid}"
      ds.add_child(signed_info_element.root)

      sv = Nokogiri::XML::Node.new('ds:SignatureValue', @doc)
      sv['Id'] = "xmldsig-#{uuid}-sigvalue"
      sv.content = signature_value
      ds.add_child(sv)

      ds.add_child(key_info.root)

      dsobj = Nokogiri::XML::Node.new('ds:Object', @doc)
      dsobj['Id'] = "XadesObjectId-xmldsig-#{uuid}" # XADES_OBJECT_ID
      qp = Nokogiri::XML::Node.new('xades:QualifyingProperties', @doc)
      qp['Id'] = "QualifyingProperties-xmldsig-#{uuid}"
      qp['xmlns:ds'] = DSIG
      qp['Target'] = "#xmldsig-#{uuid}"
      qp['xmlns:xades'] = XADES

      qp.add_child(signed_properties.root)

      dsobj.add_child(qp)
      ds.add_child(dsobj)

      name = @doc.root.namespace
      @doc.root.namespace = nil
      @doc.root.add_child(ds)
      @doc.root.namespace = name

      @doc.to_xml(save_with: Nokogiri::XML::Node::SaveOptions::AS_XML).gsub(/\r|\n/, '')
    end

    private

    def build_key_info_element
      builder = Nokogiri::XML::Builder.new
      attributes = {
        'xmlns:T' => 'urn:ticketbai:emision',
        'xmlns:ds' => 'http://www.w3.org/2000/09/xmldsig#',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'Id' => "KeyInfoId-xmldsig-#{uuid}"
      }

      builder.send('ds:KeyInfo', attributes) do |ki|
        ki.send('ds:X509Data') do |kd|
          kd.send('ds:X509Certificate', @x509.to_pem.to_s.gsub('-----BEGIN CERTIFICATE-----', '').gsub('-----END CERTIFICATE-----', '').gsub(/\n|\r/, ''))
        end
        ki.send('ds:KeyValue') do |kv|
          kv.send('ds:RSAKeyValue') do |rv|
            rv.send('ds:Modulus', Base64.encode64(@x509.public_key.params['n'].to_s(2)).gsub("\n", ''))
            rv.send('ds:Exponent', Base64.encode64(@x509.public_key.params['e'].to_s(2)).gsub("\n", ''))
          end
        end
      end

      builder.doc
    end

    def build_signed_properties_element
      cert_digest = compute_digest(@x509.to_der, algorithm(SHA256))
      signing_time = DateTime.now.rfc3339

      builder = Nokogiri::XML::Builder.new
      attributes = {
        'xmlns:T' => 'urn:ticketbai:emision',
        'xmlns:ds' => 'http://www.w3.org/2000/09/xmldsig#',
        'xmlns:xades' => 'http://uri.etsi.org/01903/v1.3.2#',
        'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance',
        'Id' => "xmldsig-#{uuid}-signedprops"
      }

      builder.send('xades:SignedProperties', attributes) do |sp|
        sp.send('xades:SignedSignatureProperties') do |ssp|
          ssp.send('xades:SigningTime', signing_time)
          ssp.send('xades:SigningCertificate') do |sc|
            sc.send('xades:Cert') do |c|
              c.send('xades:CertDigest') do |xcd|
                xcd.send('ds:DigestMethod', { 'Algorithm' => SHA256 })
                xcd.send('ds:DigestValue', cert_digest)
              end
              c.send('xades:IssuerSerial') do |is|
                is.send('ds:X509IssuerName', @x509.issuer.to_a.reverse.map { |x| x[0..1].join('=') }.join(', '))
                is.send('ds:X509SerialNumber', @x509.serial.to_s)
              end
            end
          end

          ssp.send('xades:SignaturePolicyIdentifier') do |spi|
            spi.send('xades:SignaturePolicyId') do |spi2|
              spi2.send('xades:SigPolicyId') do |spi3|
                spi3.send('xades:Identifier', POLITICA_URL)
                spi3.send('xades:Description', POLITICA_NAME)
              end

              spi2.send('xades:SigPolicyHash') do |sph|
                sph.send('ds:DigestMethod', { 'Algorithm' => 'http://www.w3.org/2001/04/xmlenc#sha256' })
                sph.send('ds:DigestValue', POLITICA_DIGEST)
              end

              spi2.send('xades:SigPolicyQualifiers') do |spqs|
                spqs.send('xades:SigPolicyQualifier') do |spq|
                  spq.send('xades:SPURI', POLITICA_URL)
                end
              end
            end
          end
        end
        sp.send('xades:SignedDataObjectProperties') do |sdop|
          sdop.send('xades:DataObjectFormat', { 'ObjectReference' => "#xmldsig-#{uuid}-ref0" }) do |dof|
            dof.send('xades:ObjectIdentifier') do |oi|
              oi.send('xades:Identifier', { 'Qualifier' => 'OIDAsURN' }, 'urn:oid:1.2.840.10003.5.109.10')
            end
            dof.send('xades:MimeType', 'text/xml')
            dof.send('xades:Encoding', 'UTF-8')
          end
        end
      end

      builder.doc
    end

    def build_signed_info_element(key_info_element, signed_props_element)
      builder = Nokogiri::XML::Builder.new

      builder.send('ds:SignedInfo',
                   { 'xmlns:T' => 'urn:ticketbai:emision', 'xmlns:ds' => 'http://www.w3.org/2000/09/xmldsig#',
                     'xmlns:xsi' => 'http://www.w3.org/2001/XMLSchema-instance' }) do |si|
        si.send('ds:CanonicalizationMethod', { 'Algorithm' => C14N })
        si.send('ds:SignatureMethod', { 'Algorithm' => RSA_SHA256 })

        si.send('ds:Reference', { 'Type' => 'http://uri.etsi.org/01903#SignedProperties', 'URI' => "#xmldsig-#{uuid}-signedprops" }) do |r|
          r.send('ds:Transforms') do |t|
            t.send('ds:Transform', { 'Algorithm' => C14N })
          end
          r.send('ds:DigestMethod', { 'Algorithm' => SHA256 })
          r.send('ds:DigestValue', digest_document(signed_props_element, SHA256, true))
        end

        si.send('ds:Reference', { 'Id' => 'ReferenceKeyInfo', 'URI' => "#KeyInfoId-xmldsig-#{uuid}" }) do |r|
          r.send('ds:Transforms') do |t|
            t.send('ds:Transform', { 'Algorithm' => C14N })
          end
          r.send('ds:DigestMethod', { 'Algorithm' => SHA256 })
          r.send('ds:DigestValue', digest_document(key_info_element, SHA256, true))
        end

        si.send('ds:Reference', { 'Id' => "xmldsig-#{uuid}-ref0", 'Type' => 'http://www.w3.org/2000/09/xmldsig#Object', 'URI' => '' }) do |r|
          r.send('ds:Transforms') do |t|
            t.send('ds:Transform', { 'Algorithm' => ENVELOPED_SIG })
            t.send('ds:Transform', { 'Algorithm' => C14N })
          end
          r.send('ds:DigestMethod', { 'Algorithm' => SHA256 })
          r.send('ds:DigestValue', digest_document(@doc, SHA256))
        end
      end

      builder.doc
    end

    def digest_document(doc, digest_algorithm = SHA256, strip = false)
      compute_digest(canonicalize_document(doc, strip), algorithm(digest_algorithm))
    end

    def canonicalize_document(doc, strip = false)
      doc.canonicalize(canon_algorithm(C14N), NAMESPACES.split)
    end

    def uuid
      @uuid ||= SecureRandom.uuid
    end

    def canon_algorithm(element)
      algorithm = element

      case algorithm
      when 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315',
            'http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments'
        Nokogiri::XML::XML_C14N_1_0
      when 'http://www.w3.org/2006/12/xml-c14n11',
            'http://www.w3.org/2006/12/xml-c14n11#WithComments'
        Nokogiri::XML::XML_C14N_1_1
      else
        Nokogiri::XML::XML_C14N_EXCLUSIVE_1_0
      end
    end

    def algorithm(element)
      algorithm = element
      if algorithm.is_a?(REXML::Element)
        algorithm = element.attribute('Algorithm').value
      elsif algorithm.is_a?(Nokogiri::XML::Element)
        algorithm = element.xpath('//@Algorithm', 'xmlns:ds' => 'http://www.w3.org/2000/09/xmldsig#').first.value
      end

      algorithm = algorithm && algorithm =~ /(rsa-)?sha(.*?)$/i && Regexp.last_match(2).to_i

      case algorithm
      when 256 then OpenSSL::Digest::SHA256
      when 384 then OpenSSL::Digest::SHA384
      when 512 then OpenSSL::Digest::SHA512
      else
        OpenSSL::Digest::SHA1
      end
    end

    def compute_signature(private_key, signature_algorithm, document)
      Base64.encode64(private_key.sign(signature_algorithm, document)).gsub(/\r|\n/, '')
    end

    def compute_digest(document, digest_algorithm)
      digest = digest_algorithm.digest(document)
      Base64.encode64(digest).strip!
    end
  end
end
