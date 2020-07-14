module TceExport::MG
  module MonthlyMonitoring
    class ResourceDetailDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, purchase)
        @monthly_monitoring = monthly_monitoring
        @purchase = purchase
      end

      def generate_data
        query.map do |ba_capability|
          budget = ba_capability.budget_allocation
          capability = ba_capability.capability

          {
            tipo_registro: 13,
            cod_orgao_resp: monthly_monitoring.organ_code,
            exercicio_licitacao: purchase.year,
            nro_processo_licitatorio: purchase.process,
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

      attr_reader :purchase

      def query
        purchase.budget_allocation_capabilities.uniq
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(
          monthly_monitoring.organ_code,
          budget.budget_structure)
      end

      def execution_unit_responsible_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(
          monthly_monitoring.organ_code,
          budget)
      end

      def item_expenditure(expense_nature)
        expense_nature.split(".")[0..3].join
      end
    end

    class BudgetDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, purchase)
        @monthly_monitoring = monthly_monitoring
        @purchase = purchase
      end

      def generate_data
        query.map do |item|
          {
            tipo_registro: 11,
            cod_orgao_resp: monthly_monitoring.organ_code,
            exercicio_licitacao: purchase.year,
            nro_processo_licitatorio: purchase.process,
            nro_lote: item.lot,
            nro_item: item.item_number,
            dt_cotacao: purchase.process_date,
            dsc_item: item.material.description,
            vl_cot_precos_unitario: item.unit_price,
            quantidade: item.quantity,
            unidade: item.reference_unit,
            vl_min_alien_bens: disposals_of_assets_value,
          }
        end
      end

      private

      attr_reader :purchase

      def query
        purchase.items
      end

      def execution_unit_responsible_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(
          monthly_monitoring.organ_code,
          budget)
      end

      def disposals_of_assets_value
        return 0.0 if !purchase.disposals_of_assets? && !purchase.auction?

        purchase.minimum_bid_to_disposal
      end
    end

    class PurchaseOpeningDataGenerator < DataGeneratorBase
      def generate_data
        query.map do |purchase|
          {
            tipo_registro: 10,
            cod_orgao_resp: monthly_monitoring.organ_code,
            exercicio_licitacao: purchase.year,
            nro_processo_licitatorio: purchase.process,
            cod_modalidade_licitacao: modality(purchase),
            nro_modalidade: purchase.modality_number,
            natureza_procedimento: object_type_nature(purchase),
            dt_abertura: purchase.process_date,
            dt_edital_convite: purchase.process_date,
            dt_publicacao_edital_do: publication_edital_official_date(purchase),
            dt_publicacao_edital_veiculo1: publication_edital_vehicle1_date(purchase),
            veiculo1_publicacao: publication_edital_vehicle1_circulation_type(purchase),
            dt_publicacao_edital_veiculo2: publication_edital_vehicle2_date(purchase),
            veiculo2_publicacao: publication_edital_vehicle2_circulation_type(purchase),
            dt_recebimento_doc: purchase.authorization_envelope_opening_date,
            tipo_licitacao: licitation_kind(purchase),
            natureza_objeto: object_type(purchase),
            objeto: purchase.description,
            regime_execucao_obras: execution_type_construction(purchase),
            nro_convidado: invited_number(purchase),
            clausulaProgramacao: purchase.extension_clause,
            unidade_medida_prazo_execucao: period_unit(purchase),
            prazo_execucao: period(purchase),
            forma_pagamento: purchase.payment_method.to_s,
            criterio_aceitabilidade: purchase.judgment_form.to_s,
            desconto_tabela: discount_on_table(purchase),
            budget_allocations: budget_allocations(purchase),
            capabilities: capabilities(purchase)
          }
        end
      end

      private

      def query
        LicitationProcess.by_type_of_purchase(PurchaseProcessTypeOfPurchase::LICITATION)
          .by_ratification_month_and_year(monthly_monitoring.month, monthly_monitoring.year)
      end

      def execution_unit_responsible_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(
          monthly_monitoring.organ_code,
          budget)
      end

      def capabilities(purchase)
        ResourceDetailDataGenerator.new(monthly_monitoring, purchase).generate_data
      end

      def budget_allocations(purchase)
        BudgetDataGenerator.new(monthly_monitoring, purchase).generate_data
      end

      def discount_on_table(purchase)
        purchase.judgment_form_higher_discount_on_table? ? 1 : 2

      end

      def period(purchase)
        if purchase.period_unit_day? || purchase.period_unit_month?
          purchase.period
        else
          purchase.period * 12
        end
      end

      def period_unit(purchase)
        return 1 if purchase.period_unit_day?
        return 2 if purchase.period_unit_month?
        return 2 if purchase.period_unit_year?
      end

      def invited_number(purchase)
        return unless purchase.invitation?

        purchase.bidders.count
      end

      def execution_type_construction(purchase)
        return unless purchase.construction_and_engineering_services?

        return 1 if purchsae.global_price?
        return 2 if purchsae.unit_price?
        return 3 if purchsae.integral?
        return 4 if purchsae.task?
        return 5 if purchsae.direct?
      end

      def licitation_kind(purchase)
        return unless purchase.judgment_form

        if purchase.judgment_form_lowest_price? || purchase.judgment_form_higher_discount_on_lot? ||
          purchase.judgment_form_higher_discount_on_item? || purchase.judgment_form_higher_discount_on_table?

          return 1
        end

        return 2 if purchase.judgment_form_best_technique?
        return 3 if purchase.judgment_form_technical_and_price?
        return 4 if purchase.judgment_form_best_auction_or_offer?
      end

      def object_type(purchase)
        return 1 if purchase.construction_and_engineering_services?
        return 2 if purchase.purchase_and_services?
        return 3 if purchase.property_lease?
        return 4 if purchase.concessions_and_permits?
        return 6 if purchase.disposals_of_assets?
      end

      def modality(purchase)
        return 1 if purchase.invitation?
        return 2 if purchase.taken_price?
        return 3 if purchase.concurrence?
        return 4 if purchase.competition?
        return 5 if purchase.trading? && !purchase.eletronic_trading?
        return 6 if purchase.trading? && purchase.eletronic_trading?
        return 7 if purchase.auction?
      end

      def object_type_nature(purchase)
        purchase.price_registration? ? 2 : 1
      end

      def publication_edital_official_date(purchase)
        publication_edital_official(purchase).try(:publication_date)
      end

      def publication_edital_official(purchase)
        purchase.publications.edital.union_official_daily.order(:publication_date).last ||
          purchase.publications.edital.state_official_daily.order(:publication_date).last ||
          purchase.publications.edital.city_official_daily.order(:publication_date).last  ||
          purchase.publications.edital.public_mural.order(:publication_date).last
      end

      def publication_edital_vehicle1_date(purchase)
        publication_edital_vehicle1(purchase).try(:publication_date)
      end

      def publication_edital_vehicle1_circulation_type(purchase)
        publication_edital_vehicle1(purchase).try(:circulation_type_humanize)
      end

      def publication_edital_vehicle2_date(purchase)
        publication_edital_vehicle2(purchase).try(:publication_date)
      end

      def publication_edital_vehicle2_circulation_type(purchase)
        publication_edital_vehicle2(purchase).try(:circulation_type_humanize)
      end

      def publication_edital_vehicle1(purchase)
        publication_edidal_vehicles(purchase).first
      end

      def publication_edital_vehicle2(purchase)
        publication_edidal_vehicles(purchase).second
      end

      def publication_edidal_vehicles(purchase)
        publications = []

        publications += purchase.publications.edital.national_newspaper.order('publication_date DESC')
        publications += purchase.publications.edital.state_newspaper.order('publication_date DESC')
        publications += purchase.publications.edital.municipal_journal.order('publication_date DESC')
        publications += purchase.publications.edital.regional_newspaper.order('publication_date DESC')
        publications += purchase.publications.edital.internet.order('publication_date DESC')

        publications.slice(0..1)
      end
    end

    class PurchaseFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao_resp, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub_resp, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :cod_modalidade_licitacao, position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_modalidade, position: 6, size: 10, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :natureza_procedimento, position: 7, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :dt_abertura, position: 8, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :dt_edital_convite, position: 9, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :dt_publicacao_edital_do, position: 10, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :dt_publicacao_edital_veiculo1, position: 11, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :veiculo1_publicacao, position: 12, size: 50, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :dt_publicacao_edital_veiculo2, position: 13, size: 8, min_size: 8, required: false, caster: Casters::DateCaster
      attribute :veiculo2_publicacao, position: 14, size: 50, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :dt_recebimento_doc, position: 15, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :tipo_licitacao, position: 16, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :natureza_objeto, position: 17, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :objeto, position: 18, size: 250, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :regime_execucao_obras, position: 19, size: 1, min_size: 1, required: false, caster: Casters::IntegerCaster
      attribute :nro_convidado, position: 20, size: 3, min_size: 1, required: false, caster: Casters::IntegerCaster
      attribute :clausulaProgramacao, position: 21, size: 250, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :unidade_medida_prazo_execucao, position: 22, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :prazo_execucao, position: 23, size: 4, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :forma_pagamento, position: 24, size: 80, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :criterio_aceitabilidade, position: 25, size: 80, min_size: 1, required: false, caster: Casters::TextCaster
      attribute :desconto_tabela, position: 26, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class BudgetDetailFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao_resp, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub_resp, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :nro_lote, position: 5, size: 4, min_size: 1, required: false, caster: Casters::IntegerCaster
      attribute :nro_item, position: 6, size: 4, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :dt_cotacao, position: 7, size: 8, min_size: 8, required: true, caster: Casters::DateCaster
      attribute :dsc_item, position: 8, size: 250, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :vl_cot_precos_unitario, position: 9, size: 13, min_size: 1, precision: 4, required: true, caster: Casters::PrecisionCaster
      attribute :quantidade, position: 10, size: 13, min_size: 1, precision: 4, required: true, caster: Casters::PrecisionCaster
      attribute :unidade, position: 11, size: 50, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :vl_min_alien_bens, position: 12, size: 13, min_size: 1, required: true, caster: Casters::DecimalCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class ResourceDetailFormatter < FormatterBase
      attribute :tipo_registro, position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao_resp, position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub_resp, position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao, position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :cod_orgao, position: 5, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub, position: 6, multiple_size: [5, 8], required: true, caster: Casters::TextCaster
      attribute :cod_funcao, position: 7, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_sub_funcao, position: 8, size: 3, min_size: 3, required: true, caster: Casters::TextCaster
      attribute :cod_programa, position: 9, size: 4, min_size: 4, required: true, caster: Casters::TextCaster
      attribute :id_acao, position: 10, size: 4, min_size: 4, required: true, caster: Casters::TextCaster
      attribute :id_sub_acao, position: 11, size: 4, min_size: 4, required: false, caster: Casters::TextCaster
      attribute :elemento_despesa, position: 12, size: 6, min_size: 6, required: true, caster: Casters::IntegerCaster
      attribute :cod_font_recursos, position: 13, size: 3, min_size: 3, required: true, caster: Casters::IntegerCaster
      attribute :vl_recurso, position: 14, size: 13, min_size: 1, required: true, caster: Casters::DecimalCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class PurchaseOpeningGenerator < GeneratorBase
      acronym 'ABERLIC'

      formatters purchase_formatter: PurchaseFormatter,
                 budget_detail_formatter: BudgetDetailFormatter,
                 resource_detail_formatter: ResourceDetailFormatter

      formats :format_purchase, :format_budget_details, :format_resource_details

      private

      def format_purchase(data)
        lines << purchase_formatter.new(data.except(:capabilities, :budget_allocations), self).to_s
      end

      def format_budget_details(data)
        return unless data[:budget_allocations]

        data[:budget_allocations].each do |budget_data|
          lines << budget_detail_formatter.new(budget_data, self).to_s
        end
      end

      def format_resource_details(data)
        return unless data[:capabilities]

        data[:capabilities].each do |capability_data|
          lines << resource_detail_formatter.new(capability_data, self).to_s
        end
      end
    end
  end
end
