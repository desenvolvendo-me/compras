module TceExport::MG
  module MonthlyMonitoring
    class PartnerDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, bidder)
        @monthly_monitoring = monthly_monitoring
        @bidder = bidder
      end

      def generate_data
        return unless bidder.company?

        query.map do |partner|
          {
            tipo_registro: 11,
            cod_orgao: monthly_monitoring.organ_code,
            cod_unidade_sub: budget_structure_code(bidder.execution_unit_responsible),
            exercicio_licitacao: bidder.licitation_process_year,
            nro_processo_licitatorio: bidder.licitation_process_process,
            tipo_documento_cnpj_empresa_hablic: 6,
            cnpj_empresa_hablic: only_numbers(bidder.identity_document),
            tipo_documento_socio: 1,
            nro_documento_socio: only_numbers(partner.cpf),
            nome_socio: partner.to_s,
            tipo_participacao: society_kind(partner)
          }
        end
      end

      private

      attr_reader :bidder

      def query
        bidder.creditor_company_partners
      end

      def society_kind(partner)
        if partner.society_kind_legal_representative?
          1
        elsif partner.society_kind_other_company_shareholder_members?
          2
        end
      end

      def budget_structure_code(budget)
        return unless budget

        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    class BiddingAuthorizationDataGenerator < DataGeneratorBase
      def generate_data
        query.map do |bidder|
          {
            tipo_registro: 10,
            cod_orgao: monthly_monitoring.organ_code,
            cod_unidade_sub: budget_structure_code(bidder.execution_unit_responsible),
            exercicio_licitacao: bidder.licitation_process_year,
            nro_processo_licitatorio: bidder.licitation_process_process,
            tipo_documento: document_kind(bidder),
            nro_documento: only_numbers(bidder.identity_document),
            nom_razao_social: bidder.name,
            # Preferi infringir Demeter do que delegar o custom_data, até achar uma solução melhor
            objeto_social: bidder.creditor.objeto_social_do_credor,
            orgao_resp_registro: organ_responsible(bidder),
            data_registro: bidder.creditor_commercial_registration_date,
            nro_registro: bidder.creditor_commercial_registration_number,
            data_registro_cvm: bidder.creditor.data_do_registro_cvm, # custom_data
            nro_registro_cvm: bidder.creditor.numero_do_registro_cvm, #custom_data
            nro_inscricao_estadual: only_numbers(bidder.state_registration),
            uf_inscricao_estatual: bidder.uf_state_registration,
            nro_certidao_regularidade_inss: document_field(bidder, :inss, :document_number),
            dt_emissao_certidao_regularidade_inss: document_field(bidder, :inss, :emission_date),
            dt_validade_certidao_regularidade_inss: document_field(bidder, :inss, :validity),
            nro_certidao_regularidade_fgts: document_field(bidder, :fgts, :document_number),
            dt_emissao_certidao_regularidade_fgts: document_field(bidder, :fgts, :emission_date),
            dt_validade_certidao_regularidade_fgts: document_field(bidder, :fgts, :validity),
            nro_cndt: document_field(bidder, :debts, :document_number),
            dt_emissao_cndt: document_field(bidder, :debts, :emission_date),
            dt_validade_cndt: document_field(bidder, :debts, :validity),
            dt_habilitacao: bidder.habilitation_date,
            presenca_licitantes: recording_attendance(bidder),
            renuncia_recurso:renounce_resource(bidder),
            partners: generate_parners(bidder)
          }
        end
      end

      private

      def query
        Bidder.type_of_purchase_licitation.enabled.by_ratification_month_and_year(monthly_monitoring.month, monthly_monitoring.year).order(:id).uniq
      end

      def generate_parners(bidder)
        PartnerDataGenerator.new(monthly_monitoring, bidder).generate_data
      end

      def document_kind(bidder)
        bidder.company? ? 2 : 1
      end

      def organ_responsible(bidder)
        case bidder.creditor_organ_responsible_for_registration
        when OrganResponsible::RECORDS_OFFICE
          1
        when OrganResponsible::PAPERS_AND_DOCUMENTS
          1
        when OrganResponsible::COMMERCIAL_REGISTRY
          2
        end
      end

      def document(bidder, habilitation_kind)
        bidder.documents.by_habilitation_kind(habilitation_kind).last
      end

      def document_field(bidder, kind, field)
        document = case kind
                   when :inss
                     document(bidder, HabilitationKind::CERTIFICATE_REGULARITY_INSS)
                   when :fgts
                     document(bidder, HabilitationKind::CERTIFICATE_REGULARITY_FGTS)
                   when :debts
                     document(bidder, HabilitationKind::CLEARANCE_CERTIFICATE_LABOR_DEBTS)
                   end

        document.try(field)
      end

      def recording_attendance(bidder)
        bidder.recording_attendance ? 1 : 2
      end

      def renounce_resource(bidder)
        bidder.renounce_resource ? 1 : 2
      end

      def budget_structure_code(budget)
        return unless budget

        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    class BiddingAuthorizationFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_documento, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_documento, position: 6, size: 14, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :nom_razao_social, position: 7, size: 120, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :objeto_social, position: 8, size: 250, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :orgao_resp_registro, position: 9, size: 1, min_size: 1, required: false, caster: Casters::IntegerCaster
      attribute :data_registro, position: 10, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :nro_registro, position: 11, size: 20, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :data_registro_cvm, position: 12, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :nro_registro_cvm, position: 13, size: 20, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :nro_inscricao_estadual, position: 14, size: 30, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :uf_inscricao_estatual, position: 15, size: 2, min_size: 2, required: false, upcase: true, caster: Casters::TextCaster
      attribute :nro_certidao_regularidade_inss, position: 16, size: 30, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :dt_emissao_certidao_regularidade_inss, position: 17, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :dt_validade_certidao_regularidade_inss, position: 18, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :nro_certidao_regularidade_fgts, position: 19, size: 30, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :dt_emissao_certidao_regularidade_fgts, position: 20, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :dt_validade_certidao_regularidade_fgts, position: 21, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :nro_cndt, position: 22, size: 30, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :dt_emissao_cndt, position: 23, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :dt_validade_cndt, position: 24, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :dt_habilitacao, position: 25, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :presenca_licitantes, position: 26, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :renuncia_recurso, position: 27, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class PartnerFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_documento_cnpj_empresa_hablic, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :cnpj_empresa_hablic, position: 6, size: 14, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_documento_socio, position: 7, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_documento_socio, position: 8, size: 14, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :nome_socio, position: 9, size: 120, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_participacao, position: 10, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end


    class BiddingAuthorizationGenerator < GeneratorBase
      acronym 'HABLIC'

      formatters bidder_formatter: BiddingAuthorizationFormatter,
                 partner_formatter: PartnerFormatter

      formats :format_bidder, :format_partners

      private

      def format_bidder(data)
        lines << bidder_formatter.new(data.except(:partners), self).to_s
      end

      def format_partners(data)
        return unless data[:partners]

        data[:partners].each { |partner_data| format_partner(partner_data) }
      end

      def format_partner(partner_data)
        lines << partner_formatter.new(partner_data, self).to_s
      end
    end
  end
end
