module TceExport::MG
  module MonthlyMonitoring
    class RegulatoryActDataGenerator < DataGeneratorBase
      def generate_data
        query.map do |regulatory_act|
          {
            cod_orgao: monthly_monitoring.prefecture.organ_code,
            tipo_decreto: regulatory_act.regulatory_act_type,
            nro_decreto_municipal: regulatory_act.act_number,
            data_decreto_municipal: regulatory_act.creation_date,
            data_publicacao_decreto_municipal: regulatory_act.publication_date
          }
        end
      end

      private

      def query
        RegulatoryAct.trading_or_price_registration.order(:act_number)
      end
    end

    class RegulatoryActFormatter
      include Typecaster

      output_separator ";"

      attribute :cod_orgao, position: 0, size: 2, min_size: 2, required: true,
                caster: Casters::TextCaster
      attribute :tipo_decreto, position: 1, size: 1, min_size: 1, required: true,
                caster: Casters::IntegerCaster
      attribute :nro_decreto_municipal, position: 2, size: 8, min_size: 1,
                required: true, caster: Casters::IntegerCaster
      attribute :data_decreto_municipal, position: 3, size: 8, min_size: 8,
                required: true, caster: Casters::DateCaster
      attribute :data_publicacao_decreto_municipal, position: 4, size: 8,
                min_size: 8, required: true, caster: Casters::DateCaster
    end

    class RegulatoryActGenerator < GeneratorBase
      acronym 'REGLIC'

      formatters formatter: RegulatoryActFormatter

      formats :format_data

      private

      def format_data(data)
        formatter.new(data).to_s
      end
    end
  end
end
