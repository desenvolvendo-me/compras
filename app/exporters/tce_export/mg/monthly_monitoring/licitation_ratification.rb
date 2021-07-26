module TceExport::MG
  module MonthlyMonitoring
    class LicitationRatificationDataGenerator < DataGeneratorBase
      def generate_data
        query.map do |ratification|
          {
            tipo_registro: 10,
            cod_orgao: monthly_monitoring.organ_code,
            exercicio_licitacao: ratification.licitation_process_year,
            nro_processo_licitatorio: ratification.licitation_process_process.to_s,
            tp_documento: tp_documento(ratification.creditor),
            nro_documento: only_numbers(ratification.creditor_identity_document),
            nro_lote: ratification.lot,
            nro_item: ratification.item.item_number,
            dsc_produto_servico: ratification.item.description,
            quantidade: quantidade(ratification.item),
            vl_homologado: ratification.unit_price,
            ratification_date_detail: generate_ratification_date_detail(ratification)
          }
        end
      end

      private

      def query
        LicitationProcessRatificationItem.type_of_purchase_licitation.by_ratification_month_and_year(
          monthly_monitoring.month, monthly_monitoring.year).order(:id)
      end

      def tp_documento(creditor)
        creditor.company? ? 2 : 1
      end

      def quantidade(item)
        item.material.control_amount ? item.quantity : 1
      end

      def generate_ratification_date_detail(ratification)
        RatificationDateDetailDataGenerator.new(monthly_monitoring, ratification).
          generate_data
      end

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    class RatificationDateDetailDataGenerator < DataGeneratorBase
      def initialize(monthly_monitoring, ratification)
        @monthly_monitoring = monthly_monitoring
        @ratification = ratification
      end

      def generate_data
        {
          tipo_registro: 30,
          cod_orgao: monthly_monitoring.organ_code,
          exercicio_licitacao: ratification.licitation_process_year,
          nro_processo_licitatorio: ratification.licitation_process_process.to_s,
          dt_homologacao: ratification.licitation_process_ratification.ratification_date,
          dt_adjuticacao: ratification.licitation_process_ratification.adjudication_date
        }
      end

      private

      attr_reader :ratification

      def budget_structure_code(budget)
        Formatters::BudgetStructureCodeFormatter.new(monthly_monitoring.organ_code, budget)
      end
    end

    class LicitationRatificationFormatter < FormatterBase
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
      attribute :quantidade,               position: 10, size: 13, min_size: 1, required: true, precision: 4, caster: Casters::PrecisionCaster
      attribute :vl_homologado,            position: 11, size: 13, min_size: 1, required: true, precision: 4, caster: Casters::PrecisionCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class RatificationDateDetailFormatter < FormatterBase
      attribute :tipo_registro,            position: 0, size: 2, min_size: 2, required: true, caster: Casters::IntegerCaster
      attribute :cod_orgao,                position: 1, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
      attribute :cod_unidade_sub,          position: 2, multiple_size: [5, 8], required: false, caster: Casters::TextCaster
      attribute :exercicio_licitacao,      position: 3, size: 4, min_size: 4, required: true, caster: Casters::IntegerCaster
      attribute :nro_processo_licitatorio, position: 4, size: 12, min_size: 1, required: true, caster: Casters::TextCaster
      attribute :dt_homologacao,           position: 5, size: 8, required: true, caster: Casters::DateCaster
      attribute :dt_adjuticacao,           position: 6, size: 8, required: true, caster: Casters::DateCaster

      def error_description(attribute, error_type)
        [
          "tipo_registro: #{data[:tipo_registro]}",
          "nro_processo_licitatorio: #{data[:nro_processo_licitatorio]}",
          "exercicio_licitacao: #{data[:exercicio_licitacao]}",
          "#{attribute}: #{data[attribute]}"
        ].join("\n")
      end
    end

    class LicitationRatificationGenerator < GeneratorBase
      acronym 'HOMOLIC'

      formatters licitation_ratification_formatter: LicitationRatificationFormatter,
                 ratification_date_detail_formatter: RatificationDateDetailFormatter

      formats :format_licitation_ratification, :format_ratification_date_detail

      private

      def format_licitation_ratification(data)
        lines << licitation_ratification_formatter.new(data.except(:ratification_date_detail), self).to_s
      end

      def format_ratification_date_detail(data)
        lines << ratification_date_detail_formatter.new(data[:ratification_date_detail], self).to_s
      end
    end
  end
end
