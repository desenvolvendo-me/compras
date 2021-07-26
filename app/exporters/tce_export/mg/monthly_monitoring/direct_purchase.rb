module TceExport::MG
  module MonthlyMonitoring
    class ContractedCreditorDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, process)
        @monthly_monitoring = monthly_monitoring
        @process = process
      end

      def generate_data
        query.map do |item|
          creditor = item.creditor

          {
            tipo_registro: 14,
            cod_orgao_resp: monthly_monitoring.organ_code,
            exercicio_processo: process.year,
            nro_processo: process.process,
            tipo_processo: type_of_removal(process),
            tipo_documento: document_type(creditor),
            nro_documento: only_numbers(creditor.identity_document),
            nom_razao_social: creditor.name,
            nro_inscricao_estadual: only_numbers(creditor.state_registration),
            uf_inscricao_estadual: creditor.uf_state_registration,
            nro_certidao_regularidade_inss: document_field(creditor, :inss, :document_number),
            dt_emissao_certidao_regularidade_inss: document_field(creditor, :inss, :emission_date),
            dt_validade_certidao_regularidade_inss: document_field(creditor, :inss, :validity),
            nro_certidao_regularidade_fgts: document_field(creditor, :fgts, :document_number),
            dt_emissao_certidao_regularidade_fgts: document_field(creditor, :fgts, :emission_date),
            dt_validade_certidao_regularidade_fgts: document_field(creditor, :fgts, :validity),
            nro_cndt: document_field(creditor, :debts, :document_number),
            dt_emissao_cndt: document_field(creditor, :debts, :emission_date),
            dt_validade_cndt: document_field(creditor, :debts, :validity),
            nro_lote: item.lot,
            nro_item: item.item_number,
            quantidade: item.quantity,
            vlr_item: item.unit_price
          }
        end
      end

      private

      attr_reader :process

      def query
        process.items
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def type_of_removal(process)
        return 1 if process.type_of_removal_removal_justified? ||
          process.type_of_removal_removal_by_limit? ||
          process.type_of_removal_dispensation_justified_accreditation? ||
          process.type_of_removal_other_reasons_to_removal? ||
          process.type_of_removal_call?

        return 2 if process.type_of_removal_removal_by_ineligibility? ||
          process.type_of_removal_unenforceability_accreditation?
      end

      def document_type(creditor)
        creditor.company? ? 2 : 1
      end

      def document(creditor, habilitation_kind)
        creditor.documents.by_habilitation_kind(habilitation_kind).last
      end

      def document_field(creditor, kind, field)
        document = case kind
                   when :inss
                     document(creditor, HabilitationKind::CERTIFICATE_REGULARITY_INSS)
                   when :fgts
                     document(creditor, HabilitationKind::CERTIFICATE_REGULARITY_FGTS)
                   when :debts
                     document(creditor, HabilitationKind::CLEARANCE_CERTIFICATE_LABOR_DEBTS)
                   end

        document.try(field)
      end
    end

    class CapabilityDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, process)
        @monthly_monitoring = monthly_monitoring
        @process = process
      end

      def generate_data
        query.map do |ba_capability|
          budget = ba_capability.budget_allocation
          capability = ba_capability.capability

          {
            tipo_registro: 13,
            cod_orgao_resp: monthly_monitoring.organ_code,
            exercicio_processo: process.year,
            nro_processo: process.process,
            tipo_processo: type_of_removal(process),
            cod_orgao: monthly_monitoring.organ_code,
            cod_unidade_sub: budget_structure_code(budget),
            cod_funcao: budget.function_code,
            cod_sub_funcao: budget.subfunction_code,
            cod_programa: budget.government_program_code,
            id_acao: budget.government_action_code,
            id_sub_acao: ' ',
            elemento_despesa: item_expenditure(budget.expense_nature_expense_nature),
            cod_font_recursos: capability.capability_source_code,
            vl_recurso: budget.amount,
          }
        end
      end

      private

      attr_reader :process

      def query
        process.budget_allocation_capabilities.uniq
      end

      def execution_unit_responsible_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def type_of_removal(process)
        return 1 if process.type_of_removal_removal_justified?
        return 2 if process.type_of_removal_removal_by_ineligibility?
        return 3 if process.type_of_removal_unenforceability_accreditation?
        return 3 if process.type_of_removal_other_reasons_to_removal?
        return 4 if process.type_of_removal_dispensation_justified_accreditation?
        return 4 if process.type_of_removal_call?
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(
          monthly_monitoring.organ_code,
          budget.budget_structure)
      end

      def item_expenditure(expense_nature)
        expense_nature.split(".")[0..3].join
      end
    end

    class ProcessItemDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, process)
        @monthly_monitoring = monthly_monitoring
        @process = process
      end

      def generate_data
        query.map do |item|
          {
            tipo_registro: 12,
            cod_orgao_resp: monthly_monitoring.organ_code,
            exercicio_processo: process.year,
            nro_processo: process.process,
            tipo_processo: type_of_removal(process),
            nro_lote: item.lot,
            nro_item: item.item_number,
            dsc_item: item.description,
            vl_cot_precos_unitatio: item.unit_price
          }
        end
      end

      private

      attr_reader :process

      def query
        process.items
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def type_of_removal(process)
        return 1 if process.type_of_removal_removal_justified?
        return 2 if process.type_of_removal_removal_by_ineligibility?
        return 3 if process.type_of_removal_unenforceability_accreditation?
        return 3 if process.type_of_removal_other_reasons_to_removal?
        return 4 if process.type_of_removal_dispensation_justified_accreditation?
        return 4 if process.type_of_removal_call?
      end
    end

    class ProcessResponsibleExemptDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, process)
        @monthly_monitoring = monthly_monitoring
        @process = process
      end

      def generate_data
        query.map do |responsible|
          {
            tipo_registro: 11,
            cod_orgao_resp: monthly_monitoring.organ_code,
            exercicio_processo: process.year,
            nro_processo: process.process,
            tipo_processo: type_of_removal(process),
            tipo_resp: responsible_kind(responsible.stage_process),
            nro_cpf_resp: only_numbers(responsible.cpf),
            nome_resp: responsible.name,
            logradouro: responsible.street_name,
            bairro_logra: responsible.neighborhood_name,
            cod_cidade_logra: responsible.city_tce_mg_code,
            uf_cidade_logra: responsible.state_acronym,
            cep_logra: only_numbers(responsible.zip_code),
            telefone: only_numbers(responsible.phone),
            email: responsible.email
          }
        end
      end

      private

      attr_reader :process

      def query
        process.process_responsibles
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def type_of_removal(process)
        return 1 if process.type_of_removal_removal_justified?
        return 2 if process.type_of_removal_removal_by_ineligibility?
        return 3 if process.type_of_removal_unenforceability_accreditation?
        return 3 if process.type_of_removal_other_reasons_to_removal?
        return 4 if process.type_of_removal_dispensation_justified_accreditation?
        return 4 if process.type_of_removal_call?
      end

      def responsible_kind(stage_process)
        case stage_process.description
        when "Autorização para abertura do procedimento de dispensa ou inexigibilidade"
          1
        when "Cotação de preços"
          2
        when "Informação de existência de recursos orçamentários"
          3
        when "Ratificação"
          4
        when "Publicação em órgão oficial"
          5
        when "Parecer Jurídico"
          6
        when "Parecer (outros)"
          7
        end
      end
    end

    class DirectPurchaseDataGenerator < DataGeneratorBase
      def generate_data
        query.map do |process|
          {
            tipo_registro: 10,
            cod_orgao_resp: monthly_monitoring.organ_code,
            exercicio_processo: process.year,
            nro_processo: process.process,
            tipo_processo: type_of_removal(process),
            dt_abertura: process.process_date,
            natureza_objeto: object_type_nature(process),
            objeto: process.description,
            justificativa: process.justification_and_legal,
            razao: process.justification,
            dt_publicacao_termo_ratificacao: last_publication(process, :publication_date),
            veiculo_publicacao: last_publication(process, :name),
            creditors: creditors(process),
            capabilities: capabilities(process),
            items: items(process),
            responsibles: responsibles(process)
          }
        end
      end

      private

      def query
        LicitationProcess.direct_purchase.
          not_removal_by_limit.
          by_ratification_month_and_year(monthly_monitoring.month, monthly_monitoring.year)
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def creditors(process)
        ContractedCreditorDataGenerator.new(monthly_monitoring, process).generate_data
      end

      def capabilities(process)
        CapabilityDataGenerator.new(monthly_monitoring, process).generate_data
      end

      def items(process)
        ProcessItemDataGenerator.new(monthly_monitoring, process).generate_data
      end

      def responsibles(process)
        ProcessResponsibleExemptDataGenerator.new(monthly_monitoring, process).generate_data
      end

      def type_of_removal(process)
        return 1 if process.type_of_removal_removal_justified?
        return 2 if process.type_of_removal_removal_by_ineligibility?
        return 3 if process.type_of_removal_unenforceability_accreditation?
        return 3 if process.type_of_removal_other_reasons_to_removal?
        return 4 if process.type_of_removal_dispensation_justified_accreditation?
        return 4 if process.type_of_removal_call?
      end

      def last_publication(process, field)
        last_publication = process.publications.confirmation.last

        last_publication.try(field)
      end

      def object_type_nature(process)
        return 1 if process.construction_and_engineering_services?
        return 2 if process.purchase_and_services?
        return 3 if process.property_lease?
      end
    end

    class ContractedCreditorFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao_resp, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub_resp, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_processo, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_processo, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :tipo_documento, position: 6, size: 1, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :nro_documento, position: 7, size: 14, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nom_razao_social, position: 8, size: 120, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :nro_inscricao_estadual, position: 9, size: 30, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :uf_inscricao_estadual, position: 10, size: 2, min_size: 2, required: false, upcase: true, caster: Casters::TextCaster
      attribute :nro_certidao_regularidade_inss, position: 11, size: 30, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :dt_emissao_certidao_regularidade_inss, position: 12, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :dt_validade_certidao_regularidade_inss, position: 13, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :nro_certidao_regularidade_fgts, position: 14, size: 30, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :dt_emissao_certidao_regularidade_fgts, position: 15, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :dt_validade_certidao_regularidade_fgts, position: 16, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :nro_cndt, position: 17, size: 30, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :dt_emissao_cndt, position: 18, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :dt_validade_cndt, position: 19, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :nro_lote, position: 20, size: 4, min_size: 1, required: false, caster: Casters::IntegerCaster
      attribute :nro_item, position: 21, size: 4, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :quantidade, position: 22, size: 13, min_size: 1, precision: 4, required: true, caster: Casters::PrecisionCaster
      attribute :vlr_item, position: 23, size: 13, min_size: 1, precision: 4, required: true, caster: Casters::PrecisionCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo: #{data[:nro_processo]}",
          "exercicio_processo: #{data[:exercicio_processo]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class CapabilityFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao_resp, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub_resp, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_processo, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_processo, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 6, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub, position: 7, multiple_size: [5, 8], required: true, caster: Casters::TextCaster
      attribute :cod_funcao, position: 8, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_sub_funcao, position: 9, size: 3, min_size: 3, required: true, caster: Casters::TextCaster
      attribute :cod_programa, position: 10, size: 4, min_size: 4, required: true, caster: Casters::TextCaster
      attribute :id_acao, position: 11, size: 4, min_size: 4, required: true, caster: Casters::TextCaster
      attribute :id_sub_acao, position: 12, size: 4, min_size: 4, required: false, caster: Casters::TextCaster
      attribute :elemento_despesa, position: 13, size: 6, min_size: 6, required: true, caster: Casters::IntegerCaster
      attribute :cod_font_recursos, position: 14, size: 3, min_size: 3, required: true, caster: Casters::IntegerCaster
      attribute :vl_recurso, position: 15, size: 13,  required: true, caster: Casters::DecimalCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo: #{data[:nro_processo]}",
          "exercicio_processo: #{data[:exercicio_processo]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ProcessItemFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao_resp, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub_resp, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_processo, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_processo, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_lote, position: 6, size: 4, min_size: 1, required: false, caster: Casters::IntegerCaster
      attribute :nro_item, position: 7, size: 4, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :dsc_item, position: 8, size: 250, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :vl_cot_precos_unitatio, position: 9, size: 13, min_size: 1, precision: 4, required: true, caster: Casters::PrecisionCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo: #{data[:nro_processo]}",
          "exercicio_processo: #{data[:exercicio_processo]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ProcessResponsibleExemptFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao_resp, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub_resp, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_processo, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_processo, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :tipo_resp, position: 6, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_cpf_resp, position: 7, size: 11, min_size: 11, required: true, caster: Casters::TextCaster
      attribute :nome_resp, position: 8, size: 50, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :logradouro, position: 9, size: 75, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :bairro_logra, position: 10, size: 75, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :cod_cidade_logra, position: 11, size: 5, min_size: 5, required: true, caster: Casters::TextCaster
      attribute :uf_cidade_logra, position: 12, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cep_logra, position: 13, size: 8, min_size: 8, required: true, caster: Casters::IntegerCaster
      attribute :telefone, position: 14, size: 10, min_size: 10, required: true, caster: Casters::IntegerCaster
      attribute :email, position: 15, size: 50, min_size: 1, required: true, caster: Casters::TextCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo: #{data[:nro_processo]}",
          "exercicio_processo: #{data[:exercicio_processo]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class DirectPurchaseFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao_resp, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub_resp, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_processo, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tipo_processo, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :dt_abertura, position: 6, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :natureza_objeto, position: 7, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :objeto, position: 8, size: 250, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :justificativa, position: 9, size: 250, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :razao, position: 10, size: 250, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :dt_publicacao_termo_ratificacao, position: 11, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :veiculo_publicacao, position: 12, size: 50, min_size: 1, required: true, caster: Casters::TextCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo: #{data[:nro_processo]}",
          "exercicio_processo: #{data[:exercicio_processo]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class DirectPurchaseGenerator < GeneratorBase
      acronym 'DISPENSA'

      formatters direct_purchase_formatter: DirectPurchaseFormatter,
        process_responsible_exempt_formatter: ProcessResponsibleExemptFormatter,
        process_item_formatter: ProcessItemFormatter,
        capability_formatter: CapabilityFormatter,
        contracted_creditor_formatter: ContractedCreditorFormatter

      formats :format_direct_purchase, :format_process_responsible_exempts,
        :format_process_items, :format_capabilities, :format_contracted_creditors

      private

      def format_direct_purchase(data)
        direct_purchase_data = data.except(:responsibles, :items, :capabilities, :creditors)

        lines << direct_purchase_formatter.new(direct_purchase_data, self).to_s
      end

      def format_process_responsible_exempts(data)
        return unless data[:responsibles]

        data[:responsibles].each { |responsible_data|
          lines << process_responsible_exempt_formatter.new(responsible_data, self).to_s
        }
      end

      def format_process_items(data)
        return unless data[:items]

        data[:items].each { |item_data|
          lines << process_item_formatter.new(item_data, self).to_s
        }
      end

      def format_capabilities(data)
        return unless data[:capabilities]

        data[:capabilities].each { |capability_data|
          lines << capability_formatter.new(capability_data, self).to_s
        }
      end

      def format_contracted_creditors(data)
        return unless data[:creditors]

        data[:creditors].each { |item_data|
          lines << contracted_creditor_formatter.new(item_data, self).to_s
        }
      end
    end
  end
end
