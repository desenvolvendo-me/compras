module TceExport::MG
  module MonthlyMonitoring
    class ContractDataGenerator < DataGeneratorBase # Registro 10
      def generate_data
        query.map do |contract|
          data = {
            tipo_registro: 10,
            cod_contrato: contract.id,
            cod_orgao: monthly_monitoring.organ_code,
            nro_contrato: contract.contract_number,
            dt_assinatura: contract.signature_date,
            nome_contratado_ou_parceiro_publico: nome_contratado(contract),
            tipo_documento: tp_documento(contract),
            nro_documento: nro_documento(contract),
            representante_legal_contratado: nome_representante_legal_contratado(contract),
            cpf_representante_legal_contratado: only_numbers(cpf_representante_legal(contract)),
            nro_processo_licitatorio: contract.licitation_process_process,
            exercicio_processo_licitatorio: contract.licitation_process_year,
            natureza_objeto: natureza_objeto(contract.licitation_process),
            objeto_contrato: contract.content,
            tipo_instrumento: 1,
            dt_inicio_vigencia: contract.start_date,
            dt_final_vigencia: contract.end_date,
            vl_contrato: contract.contract_value,
            forma_fornecimento: forma_fornecimento(contract),
            forma_pagamento: nil,
            prazo_execucao: nil,
            multa_rescisoria: multa_rescisoria(contract),
            multa_inadimplemento: multa_inadimplemento(contract),
            garantia: garantia(contract),
            signatario_contratante: contract.budget_structure_responsible,
            cpf_signatario_contratante: only_numbers(contract.budget_structure_responsible.cpf),
            dt_publicacao: contract.publication_date,
            veiculo_divulgacao: contract.dissemination_source.to_s,
            contract_item_detail: generate_contract_item_detail(contract),
            contract_pledge_item: generate_contract_pledge_item(monthly_monitoring, contract),
            creditor_item: generate_creditor_item(contract),
            termination_item: generate_termination_item(monthly_monitoring, contract)
          }
        end
      end

      private

      def query
        Contract.by_signature_date(monthly_monitoring.date.beginning_of_month..monthly_monitoring.date.end_of_month)
          .except_type_of_removal(TypeOfRemoval::REMOVAL_BY_LIMIT)
          .order(:id)
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def generate_contract_item_detail(contract)
        return if concessions_and_permits? contract.licitation_process

        ContractItemDetailDataGenerator.new(monthly_monitoring, contract).generate_data
      end

      def generate_contract_pledge_item(monthly_monitoring, contract)
        return if concessions_and_permits? contract.licitation_process

        ContractPledgeItemDataGenerator.new(monthly_monitoring, contract).generate_data
      end

      def generate_creditor_item(contract)
        #TODO verificar este método e mudar creeditors para creditor
        return
        return if contract.creditors.size < 2

        ContractCreditorItemDataGenerator.new(contract).generate_data
      end

      def generate_additive_item(monthly_monitoring, contract)
        return if concessions_and_permits? contract.licitation_process

        ContractAdditiveItemDataGenerator.new(monthly_monitoring, contract).generate_data
      end

      def generate_additive_item_detail(monthly_monitoring, contract)
        return if concessions_and_permits? contract.licitation_process

        ContractAdditiveItemDetailDataGenerator.new(monthly_monitoring, contract).generate_data
      end

      def generate_termination_item(monthly_monitoring, contract)
        ContractTerminationItemDetailDataGenerator.new(monthly_monitoring, contract).generate_data
      end

      def nome_contratado(contract)
        return nil if contract.creditor.blank?

        contract.creditor.name
      end

      def tp_documento(contract)
        return nil if contract.creditor.blank?

        contract.creditor.company? ? 2 : 1
      end

      def nro_documento(contract)
        return nil if contract.creditor.blank?

        only_numbers(contract.creditor.identity_document)
      end

      def representante_legal_contratado(creditor)
        if creditor.company?
          creditor.first_representative_individual
        else
          creditor
        end
      end

      def nome_representante_legal_contratado(contract)
        return nil if contract.creditor.blank?

        representante_legal_contratado(contract.creditor).try :name
      end

      def cpf_representante_legal(contract)
        return nil if contract.creditor.blank?

        representante_legal_contratado(contract.creditor).try :cpf
      end

      def forma_fornecimento(contract)
        return if concessions_and_permits?(contract.licitation_process)

        contract.execution_type_humanize
      end

      def multa_rescisoria(contract)
        return if concessions_and_permits? contract.licitation_process

        contract.penalty_fine
      end

      def multa_inadimplemento(contract)
        return if concessions_and_permits? contract.licitation_process

        contract.default_fine
      end

      def concessions_and_permits?(licitation_process)
        licitation_process.concessions? || licitation_process.permits?
      end

      def natureza_objeto(licitation_process)
        return 1 if licitation_process.construction_and_engineering_services?
        return 2 if licitation_process.purchase_and_services?
        return 3 if licitation_process.property_lease?
        return 4 if licitation_process.concessions?
        return 5 if licitation_process.permits?
      end

      def garantia(contract)
        case contract.contract_guarantees
          when ContractGuarantees::CASH_BOND then 1
          when ContractGuarantees::PUBLIC_DEBT_SECURITIES then 2
          when ContractGuarantees::INSURANCE then 3
          when ContractGuarantees::BANK then 4
          when ContractGuarantees::WITHOUT then 5
        end
      end
    end

    class ContractItemDetailDataGenerator < DataGeneratorBase # Registro 11
      def initialize(monthly_monitoring, contract)
        @monthly_monitoring = monthly_monitoring
        @contract = contract
      end

      def generate_data
        contract.ratifications_items.map do |item|
          {
            tipo_registro: 11,
            cod_contrato: contract.id,
            descricao_item: item.description,
            quantidade_item: item.quantity,
            unidade: item.reference_unit,
            vl_unitario_item: item.unit_price
          }
        end
      end

      private

      attr_reader :contract
    end

    class ContractPledgeItemDataGenerator < DataGeneratorBase # Registro 12
      def initialize(monthly_monitoring, contract)
        @monthly_monitoring = monthly_monitoring
        @contract = contract
      end

      def generate_data
        contract.pledges.map do |pledge|
          {
            tipo_registro: 12,
            cod_contrato: contract.id,
            cod_orgao: monthly_monitoring.organ_code,
            cod_funcao: pledge.function_code,
            cod_subfuncao: pledge.subfunction_code,
            cod_programa: pledge.government_program_code,
            cod_acao: pledge.government_action_code,
            cod_subacao: nil,
            elemento_despesa: item_expenditure(pledge.expense_nature_expense_nature),
            cod_fonte_recursos: pledge.capability_source_code
          }
        end
      end

      private

      attr_reader :contract

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def item_expenditure(expense_nature)
        expense_nature.split(".")[0..3].join # ???
      end
    end

    class ContractCreditorItemDataGenerator < DataGeneratorBase # Registro 13
      def initialize(contract)
        @contract = contract
      end

      def generate_data
        contract.creditors.map do |creditor|
          {
            tipo_registro: 13,
            cod_contrato: contract.id,
            tipo_documento: tipo_documento(creditor),
            nro_documento: nro_documento(creditor),
            nome_credor: creditor.name
          }
        end
      end

      private

      attr_reader :contract

      def tipo_documento(creditor)
        creditor.company? ? 2 : 1
      end

      def nro_documento(creditor)
        only_numbers creditor.identity_document
      end
    end

    class ContractAdditiveItemDataGenerator < DataGeneratorBase # Registro 20
      def initialize(monthly_monitoring, contract)
        @monthly_monitoring = monthly_monitoring
        @contract = contract
      end

      def generate_data
        contract.additives.map do |additive|
          {
            tipo_registro: 20,
            cod_aditivo: additive.id,
            cod_orgao: monthly_monitoring.organ_code,
            nro_contrato: contract.contract_number,
            dt_assinatura_contrato_original: contract.signature_date,
            tipo_termo_aditivo: additive_type(additive),
            dsc_alteracao: nil,
            nro_seq_termo_aditivo: additive.id,
            dt_assinatura_termo_aditivo: additive.signature_date,
            nova_data_termino: additive.end_date,
            valor_aditivo: additive.value,
            valor_atualizado_contrato: updated_value(contract, additive),
            dt_publicacao: additive.publication_date,
            veiculo_divulgacao: additive.dissemination_source.to_s
          }
        end
      end

      private

      attr_reader :monthly_monitoring, :contract

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def item_expenditure(expense_nature)
        expense_nature.split(".")[0..3].join # ???
      end
    end

    class ContractCreditorItemDataGenerator < DataGeneratorBase # Registro 13
      def initialize(contract)
        @contract = contract
      end

      def additive_type(additive)
        case additive.additive_type
          when ContractAdditiveType::EXTENSION_TERM then "01"
          when ContractAdditiveType::VALUE_ADDITIONS then "02"
          when ContractAdditiveType::VALUE_DECREASE then "03"
          when ContractAdditiveType::READJUSTMENT then "04"
          when ContractAdditiveType::RECOMPOSITION then "05"
          when ContractAdditiveType::OTHERS then "06"
        end
      end

      def updated_value(contract, additive)
        return contract.contract_value unless additive.value.present?

        contract.contract_value + additive.value
      end
    end

    class ContractAdditiveItemDetailDataGenerator < DataGeneratorBase # Registro 21
      def initialize(monthly_monitoring, contract)
        @monthly_monitoring = monthly_monitoring
        @contract = contract
      end

      def generate_data
        contract.additives.map do |additive|
          {
            tipo_registro: 21,
            cod_aditivo: additive.id
          }
        end
      end

      private

      attr_reader :monthly_monitoring, :contract
    end

    class ContractTerminationItemDetailDataGenerator < DataGeneratorBase # Registro 40
      def initialize(monthly_monitoring, contract)
        @monthly_monitoring = monthly_monitoring
        @contract = contract
      end

      def generate_data
        termination = contract.contract_termination

        return unless termination

        {
          tipo_registro: 40,
          cod_orgao: monthly_monitoring.organ_code,
          nro_contrato: contract.contract_number,
          dt_assinatura_contrato_original: contract.signature_date,
          dt_rescisao: termination.termination_date,
          vl_cancelamento_contrato: termination.termination_value
        }
      end

      private

      attr_reader :monthly_monitoring, :contract

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    ### FORMATERS

    class ContractHeaderFormatter < FormatterBase # Registro 10
      attribute :tipo_registro, position: 0, size: 2, min_size:  2, required: true, caster: Casters::IntegerCaster
      attribute :cod_contrato, position: 1, size: 15, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 2, size: 2, min_size:  2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_orcamentaria, position: 3, size: 8, min_size:  5, required: false, caster: Casters::TextCaster
      attribute :nro_contrato, position: 4, size: 14, required: true, caster: Casters::IntegerCaster
      attribute :dt_assinatura, position: 5, size: 8, min_size:  8, required: true, caster: Casters::DateCaster
      attribute :nome_contratado_ou_parceiro_publico, position: 6, size: 120, required: false, caster: Casters::TextCaster
      attribute :tipo_documento, position: 7, size: 1, min_size:  1, required: false, caster: Casters::IntegerCaster
      attribute :nro_documento, position: 8, size: 14, min_size:  11, required: false, caster: Casters::TextCaster
      attribute :representante_legal_contratado, position: 9, size: 50, required: false, caster: Casters::TextCaster
      attribute :cpf_representante_legal_contratado, position: 10, size: 11, min_size:  11, required: false, caster: Casters::TextCaster
      attribute :nro_processo_licitatorio, position: 11, size: 12, required: false, caster: Casters::TextCaster
      attribute :exercicio_processo_licitatorio, position: 12, size: 4, min_size:  4, required: false, caster: Casters::IntegerCaster
      attribute :natureza_objeto, position: 13, size: 1, min_size:  1, required: true, caster: Casters::IntegerCaster
      attribute :objeto_contrato, position: 14, size: 500, required: true, caster: Casters::TextCaster
      attribute :tipo_instrumento, position: 15, size: 1, min_size:  1, required: true, caster: Casters::IntegerCaster
      attribute :dt_inicio_vigencia, position: 16, size: 8, min_size:  8, required: true, caster: Casters::DateCaster
      attribute :dt_final_vigencia, position: 17, size: 8, min_size:  8, required: true, caster: Casters::DateCaster
      attribute :vl_contrato, position: 18, size: 13, required: true, caster: Casters::DecimalCaster
      attribute :forma_fornecimento, position: 19, size: 50, required: false, caster: Casters::TextCaster
      attribute :forma_pagamento, position: 20, size: 100, required: false, caster: Casters::TextCaster
      attribute :prazo_execucao, position: 21, size: 100, required: false, caster: Casters::TextCaster
      attribute :multa_rescisoria, position: 22, size: 100, required: false, caster: Casters::TextCaster
      attribute :multa_inadimplemento, position: 23, size: 100, required: false, caster: Casters::TextCaster
      attribute :garantia, position: 24, size: 1, min_size:  1, required: false, caster: Casters::IntegerCaster
      attribute :signatario_contratante, position: 25, size: 50, required: true, caster: Casters::TextCaster
      attribute :cpf_signatario_contratante, position: 26, size: 11, min_size:  11, required: true, caster: Casters::TextCaster
      attribute :dt_publicacao, position: 27, size: 8, min_size:  8, required: true, caster: Casters::DateCaster
      attribute :veiculo_divulgacao, position: 28, size: 50, required: true, caster: Casters::TextCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "cod_contrato: #{data[:cod_contrato]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ContractItemDetailFormatter < FormatterBase # Registro 11
      attribute :tipo_registro,    position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_contrato,     position: 1, size: 15, required: true, caster: Casters::IntegerCaster
      attribute :descricao_item,   position: 2, size: 250, required: true, caster: Casters::TextCaster
      attribute :quantidade_item,  position: 3, size: 13, required: true, precision: 4, caster: Casters::PrecisionCaster
      attribute :unidade,          position: 4, size: 50, required: true, caster: Casters::TextCaster
      attribute :vl_unitario_item, position: 5, size: 13, required: true, precision: 4, caster: Casters::PrecisionCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "cod_contrato: #{data[:cod_contrato]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ContractPledgeItemFormatter < FormatterBase # Registro 12
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required:  true, caster: Casters::IntegerCaster
      attribute :cod_contrato, position: 1, size: 15, required:  true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 2, size: 2, min_size: 2, required:  true, caster: Casters::TextCaster
      attribute :cod_unidade_orcamentaria, position: 3, size: 8, min_size: 5, required:  false, caster: Casters::TextCaster
      attribute :cod_funcao, position: 4, size: 2, min_size: 2, required:  true, caster: Casters::IntegerCaster
      attribute :cod_subfuncao, position: 5, size: 3, min_size: 3, required:  true, caster: Casters::IntegerCaster
      attribute :cod_programa, position: 6, size: 4, min_size: 4, required:  true, caster: Casters::IntegerCaster
      attribute :cod_acao, position: 7, size: 4, min_size: 4, required:  true, caster: Casters::IntegerCaster
      attribute :cod_subacao, position: 8, size: 1, min_size: 1, required:  false, caster: Casters::IntegerCaster
      attribute :elemento_despesa, position: 9, size: 6, min_size: 6, required:  true, caster: Casters::IntegerCaster
      attribute :cod_fonte_recursos, position: 10, size: 3, min_size: 3, required:  true, caster: Casters::IntegerCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "cod_contrato: #{data[:cod_contrato]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ContractCreditorItemFormatter < FormatterBase # Registro 13
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_contrato, position: 1, size: 15, required: true, caster: Casters::IntegerCaster
      attribute :tipo_documento, position: 2, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_documento, position: 3, size: 14, min_size: 11, required: true, caster: Casters::TextCaster
      attribute :nome_credor, position: 4, size: 120, required: true, caster: Casters::TextCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "cod_contrato: #{data[:cod_contrato]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ContractAdditiveItemFormatter < FormatterBase #Registro 20
      attribute :tipo_registro, position: 0, size:  2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_aditivo, position: 1, size:  15, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 2, size:  2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_orcamentaria, position: 3, size:  8, min_size: 5, required: false, caster: Casters::TextCaster
      attribute :nro_contrato, position: 4, size:  14, required: true, caster: Casters::IntegerCaster
      attribute :dt_assinatura_contrato_original, position: 5, size:  8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :tipo_termo_aditivo, position: 6, size:  2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :dsc_alteracao, position: 7, size:  250, required: false, caster: Casters::TextCaster
      attribute :nro_seq_termo_aditivo, position: 8, size:  2, min_size: 2, rjust: "0", required: true, caster: Casters::TextCaster
      attribute :dt_assinatura_termo_aditivo, position: 9, size:  8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :nova_data_termino, position: 10, size:  8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :valor_aditivo, position: 11, size:  13, required: true, caster: Casters::DecimalCaster
      attribute :valor_atualizado_contrato, position: 12, size:  13, required: true, caster: Casters::DecimalCaster
      attribute :dt_publicacao, position: 13, size:  8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :veiculo_divulgacao, position: 14, size:  50, required: true, caster: Casters::TextCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "cod_aditivo: #{data[:cod_aditivo]}",
          "nro_contrato: #{data[:nro_contrato]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ContractAdditiveItemDetailFormatter < FormatterBase # Registro 21
      attribute :tipo_registro,    position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_aditivo,      position: 1, size: 15, required: true, caster: Casters::IntegerCaster
      attribute :descricao_item,   position: 2, size: 150, required: true, caster: Casters::TextCaster
      attribute :quantidade_item,  position: 3, size: 13, required: true, precision: 4, caster: Casters::PrecisionCaster
      attribute :unidade,          position: 4, size: 50, required: true, caster: Casters::TextCaster
      attribute :vl_unitario_item, position: 5, size: 13, required: true, precision: 4, caster: Casters::PrecisionCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "cod_aditivo: #{data[:cod_aditivo]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ContractTerminationItemFormatter < FormatterBase #Registro 40
      attribute :tipo_registro, position: 0, size:  2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao, position: 1, size:  2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_orcamentaria, position: 2, size:  8, min_size: 5, required: false, caster: Casters::TextCaster
      attribute :nro_contrato, position: 3, size:  14, required: true, caster: Casters::IntegerCaster
      attribute :dt_assinatura_contrato_original, position: 4, size:  8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :dt_rescisao, position: 6, size:  8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :vl_cancelamento_contrato, position: 7, size:  13, required: true, caster: Casters::DecimalCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_contrato: #{data[:nro_contrato]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ContractGenerator < GeneratorBase
      acronym 'CONTRATO'

      formatters contract_header_formatter: ContractHeaderFormatter, # Registro 10
                 contract_item_detail_formatter: ContractItemDetailFormatter, # Registro 11
                 contract_pledge_item_formatter: ContractPledgeItemFormatter, # Registro 12
                 contract_creditor_item_formatter: ContractCreditorItemFormatter, #Registro 13
                 contract_additive_item_formatter: ContractAdditiveItemFormatter, #Registro 20
                 contract_additive_item_details_formatter: ContractAdditiveItemDetailFormatter, # Registro 21
                 contract_termination_item_formatter: ContractTerminationItemFormatter # Registro 40

      formats :format_contract_header,
              :format_contract_item_detail,
              :format_pledge_item,
              :format_contract_creditor_item,
             # :format_contract_additive_item,
             # :format_contract_additive_item_details,
              :format_contract_termination_item

      private

      def format_contract_header(data)
        data = data.except(:contract_item_detail, :contract_pledge_item, :creditor_item,
          :additive_item, :additive_item_detail, :termination_item)

        lines << contract_header_formatter.new(data, self).to_s
      end

      def format_contract_item_detail(data)
        return unless data[:contract_item_detail].present?

        lines << contract_item_detail_formatter.new(data[:contract_item_detail], self).to_s
      end

      def format_pledge_item(data)
        return unless data[:contract_pledge_item].present?

        lines << contract_pledge_item_formatter.new(data[:contract_pledge_item], self).to_s
      end

      def format_contract_creditor_item(data)
        return unless data[:creditor_item].present?

        lines << contract_creditor_item_formatter.new(data[:creditor_item], self).to_s
      end

      def format_contract_additive_item(data)
        return unless data[:additive_item].present?

        lines << contract_additive_item_formatter.new(data[:additive_item], self).to_s
      end

      def format_contract_additive_item_details(data)
        return unless data[:creditor_item_detail].present?

        lines << contract_additive_item_details_formatter.new(data[:additive_item_detail], self).to_s
      end

      def format_contract_termination_item(data)
        return unless data[:termination_item].present?

        lines << contract_termination_item_formatter.new(data[:termination_item], self).to_s
      end
    end
  end
end
