module Ticketbai
  module Nodes
    class BreakdownType
      # Exemption causes (CausaExencion):
      # E1: Exenta por el artículo 20 de la Norma Foral del IVA
      # E2: Exenta por el artículo 21 de la Norma Foral del IVA
      # E3: Exenta por el artículo 22 de la Norma Foral del IVA
      # E4: Exenta por el artículo 23 y 24 de la Norma Foral del IVA
      # E5: Exenta por el artículo 25 de la Norma Foral del IVA
      # E6: Exenta por otra causa

      # Type of non-exempt (TipoNoExenta):
      # S1: Sin inversión del sujeto pasivo
      # S2: Con inversión del sujeto pasivo
      def initialize(args = {})
        @receiver_country = args[:receiver_country]
        @invoice_amount = args[:invoice_amount]
        @invoice_vat = args[:invoice_vat]
        @invoice_vat_total = args[:invoice_vat_total]
        @receiver_in_eu = args[:receiver_in_eu]
        @simplified_invoice = args[:simplified_invoice]
      end

      # @return [Nokogiri::XML::Builder]
      def build_xml(node)
        node = Nokogiri::XML::Builder.new if node.nil?
        node.TipoDesglose do |xml|
          if (@receiver_country == 'ES') || (@receiver_country != 'ES' && @simplified_invoice)
            xml.DesgloseFactura do
              xml.Sujeta do
                if (@receiver_country != 'ES') && @simplified_invoice
                  xml.Exenta do
                    xml.DetalleExenta do
                      xml.CausaExencion @receiver_in_eu == true ? 'E6' : 'E2'
                      xml.BaseImponible @invoice_amount
                    end
                  end
                else
                  xml.NoExenta do
                    xml.DetalleNoExenta do
                      xml.TipoNoExenta 'S1'
                      xml.DesgloseIVA do
                        xml.DetalleIVA do
                          xml.BaseImponible @invoice_amount
                          xml.TipoImpositivo @invoice_vat
                          xml.CuotaImpuesto @invoice_vat_total
                        end
                      end
                    end
                  end
                end
              end
            end
          else
            xml.DesgloseTipoOperacion do
              xml.PrestacionServicios do
                xml.Sujeta do
                  xml.Exenta do
                    xml.DetalleExenta do
                      xml.CausaExencion @receiver_in_eu == true ? 'E6' : 'E2'
                      xml.BaseImponible @invoice_amount
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
