module TceExport::MG
  module MonthlyMonitoring
    class LicitationJudgmentDataGenerator < DataGeneratorBase
      def generate_data
        query.map do |proposal|
          {
            tipo_registro: 10,
            cod_orgao: monthly_monitoring.organ_code,
            cod_unidade_sub: budget_structure_code(proposal.licitation_process_execution_unit_responsible),
            exercicio_licitacao: proposal.licitation_process_year,
            nro_processo_licitatorio: proposal.licitation_process_process.to_s,
            tp_documento: tp_documento(proposal.creditor),
            nro_documento: only_numbers(proposal.creditor_identity_document),
            nro_lote: proposal.lot,
            nro_item: proposal.item.id,
            dsc_produto_servico: proposal.item.to_s,
            vl_unitario: vl_unitario(proposal),
            quantidade: quantidade(proposal.item),
            unidade: proposal.material_reference_unit,
            judgment_date_detail: generate_judment_date_detail(proposal.licitation_process)
          }
        end
      end

      private

      def query
        items = PurchaseProcessCreditorProposal.by_ratification_month_and_year(
          monthly_monitoring.month, monthly_monitoring.year).judgment_by_item.order(:id)

        lots_global = PurchaseProcessCreditorProposal.by_ratification_month_and_year(
          monthly_monitoring.month, monthly_monitoring.year).judgment_by_lot_or_global

        lots_global = lots_global.flat_map(&:realigment_prices)

        [items + lots_global].flatten.sort
      end

      def generate_judment_date_detail(licitation_process)
        JudgmentDateDetailDataGenerator.new(monthly_monitoring, licitation_process).
          generate_data
      end

      def tp_documento(creditor)
        creditor.company? ? 2 : 1
      end

      def quantidade(item)
        item.material.control_amount ? item.quantity : 1
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end

      def vl_unitario(proposal)
        realigment?(proposal) ? proposal.price : proposal.unit_price
      end

      def realigment?(proposal)
        proposal.is_a? RealigmentPrice
      end
    end

    class JudgmentDateDetailDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, purchase_process)
        @monthly_monitoring = monthly_monitoring
        @purchase_process = purchase_process
      end

      def generate_data
        {
          tipo_registro: 30,
          cod_orgao: monthly_monitoring.organ_code,
          cod_unidade_sub: budget_structure_code(purchase_process.execution_unit_responsible),
          exercicio_licitacao: purchase_process.year,
          nro_processo_licitatorio: purchase_process.process.to_s,
          dt_julgamento: purchase_process.proposal_envelope_opening_date,
          presenca_licitantes: presenca_licitantes,
          renuncia_recurso: renuncia_recurso
        }
      end

      private

      attr_reader :purchase_process

      def presenca_licitantes
        return unless bidder
        bidder.recording_attendance? ? 1 : 2
      end

      def renuncia_recurso
        return unless bidder
        bidder.renounce_resource? ? 1 : 2
      end

      def bidder
        purchase_process.bidders.any? && purchase_process.bidders.first
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    class LicitationJudgmentFormatter
      include Typecaster

      output_separator ";"

      attribute :tipo_registro,            position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao,                position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub,          position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao,      position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :tp_documento,             position: 5, size: 1, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :nro_documento,            position: 6, size: 14, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :nro_lote,                 position: 7, size: 4, min_size: 1, required: false, caster: Casters::IntegerCaster
      attribute :nro_item,                 position: 8, size: 4, min_size: 1, required: true, caster: Casters::IntegerCaster
      attribute :dsc_produto_servico,      position: 9, size: 250, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :vl_unitario,              position: 10, size: 13, min_size: 1, required: true, precision: 4, caster: Casters::PrecisionCaster
      attribute :quantidade,               position: 11, size: 13, min_size: 1, required: true, precision: 4, caster: Casters::PrecisionCaster
      attribute :unidade,                  position: 12, size: 50, min_size: 1, required: true, caster: Casters::TextCaster
    end

    class JudgmentDateDetailFormatter
      include Typecaster

      output_separator ";"

      attribute :tipo_registro,            position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao,                position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub,          position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao,      position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :dt_julgamento,            position: 5, size: 8, required: true, caster: Casters::DateCaster
      attribute :presenca_licitantes,      position: 6, size: 1, required: true, caster: Casters::IntegerCaster
      attribute :renuncia_recurso,         position: 7, size: 1, required: true, caster: Casters::IntegerCaster
    end

    class LicitationJudgmentGenerator < GeneratorBase
      acronym 'JULGLIC'

      formatters licitation_judgment_formatter: LicitationJudgmentFormatter,
                 judgment_date_detail_formatter: JudgmentDateDetailFormatter

      formats :format_licitation_judgment, :format_judgment_date_detail

      private

      def format_licitation_judgment(data)
        licitation_judgment_formatter.new(data.except(:judgment_date_detail)).to_s
      end

      def format_judgment_date_detail(data)
        judgment_date_detail_formatter.new(data[:judgment_date_detail]).to_s
      end
    end
  end
end
