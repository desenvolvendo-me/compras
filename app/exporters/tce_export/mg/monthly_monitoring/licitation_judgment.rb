module TceExport::MG
  module MonthlyMonitoring
    class LicitationJudgmentDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring)
        @last_process = nil

        super
      end

      def generate_data
        data = query.map do |proposal|
          {
            tipo_registro: 10,
            cod_orgao: monthly_monitoring.organ_code,
            exercicio_licitacao: year(proposal),
            nro_processo_licitatorio: process(proposal).to_s,
            tp_documento: tp_documento(proposal.creditor),
            nro_documento: only_numbers(proposal.creditor_identity_document),
            nro_lote: lot_number(proposal),
            nro_item: proposal.item.item_number,
            dsc_produto_servico: proposal.item.description,
            vl_unitario: vl_unitario(proposal),
            quantidade: quantidade(proposal.item),
            unidade: proposal.material_reference_unit,
            judgment_date_detail: generate_judment_date_detail(purchase_process(proposal))
          }
        end

        if data.any?
          data.last.merge!(judgment_date_detail: generate_judment_date_detail(nil))
        end

        data
      end

      private

      attr_reader :last_process

      def query
        items = PurchaseProcessCreditorProposal.type_of_purchase_licitation.by_ratification_month_and_year(
          monthly_monitoring.month, monthly_monitoring.year).judgment_by_item.order(:id)

        lots_global = PurchaseProcessCreditorProposal.type_of_purchase_licitation.by_ratification_month_and_year(
          monthly_monitoring.month, monthly_monitoring.year).judgment_by_lot_or_global

        lots_global = lots_global.flat_map(&:realignment_items)

        [items + lots_global].flatten.sort_by { |proposal| purchase_process_id(proposal) }
      end

      def generate_judment_date_detail(licitation_process)
        @last_process = licitation_process if last_process.nil?

        return if last_process == licitation_process

        data = JudgmentDateDetailDataGenerator.
          new(monthly_monitoring, last_process).
          generate_data

        @last_process = licitation_process

        data
      end

      def tp_documento(creditor)
        creditor.company? ? 2 : 1
      end

      def quantidade(item)
        item.material.control_amount ? item.quantity : 1
      end

      def vl_unitario(proposal)
        realignment?(proposal) ? proposal.price : proposal.unit_price
      end

      def realignment?(proposal)
        proposal.is_a? RealignmentPriceItem
      end

      def lot_number(proposal)
        proposal.lot || proposal.item.lot
      end

      def year(proposal)
        realignment?(proposal) ? proposal.purchase_process_year : proposal.licitation_process_year
      end

      def process(proposal)
        realignment?(proposal) ? proposal.purchase_process_process : proposal.licitation_process_process
      end

      def purchase_process(proposal)
        realignment?(proposal) ? proposal.purchase_process : proposal.licitation_process
      end

      def purchase_process_id(proposal)
        realignment?(proposal) ? proposal.purchase_process.id : proposal.licitation_process_id
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

    class LicitationJudgmentFormatter < FormatterBase
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

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class JudgmentDateDetailFormatter < FormatterBase
      attribute :tipo_registro,            position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao,                position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub,          position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao,      position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :dt_julgamento,            position: 5, size: 8, required: true, caster: Casters::DateCaster
      attribute :presenca_licitantes,      position: 6, size: 1, required: true, caster: Casters::IntegerCaster
      attribute :renuncia_recurso,         position: 7, size: 1, required: true, caster: Casters::IntegerCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class LicitationJudgmentGenerator < GeneratorBase
      acronym 'JULGLIC'

      formatters licitation_judgment_formatter: LicitationJudgmentFormatter,
                 judgment_date_detail_formatter: JudgmentDateDetailFormatter

      formats :format_licitation_judgment, :format_judgment_date_detail

      private

      def format_licitation_judgment(data)
        lines << licitation_judgment_formatter.new(data.except(:judgment_date_detail), self).to_s
      end

      def format_judgment_date_detail(data)
        return unless data[:judgment_date_detail]

        lines << judgment_date_detail_formatter.new(data[:judgment_date_detail], self).to_s
      end
    end
  end
end
