module TceExport::MG
  module MonthlyMonitoring
    class MonthlyRegulatoryAct
      def initialize(options = {})
        @generator = options.fetch(:generator) { MonthlyRegulatoryActGenerator }
        @formatter = options.fetch(:formatter) { MonthlyRegulatoryActFormatter }
      end

      def generate_file(monthly_monitoring)
        @monthly_monitoring = monthly_monitoring

        File.open(path, 'w', :encoding => 'ISO-8859-1') do |f|
          f.write(generate_data(monthly_monitoring))
        end

        filename
      end

      private

      attr_reader :generator, :formatter

      def filename
        'REGLIC.csv'
      end

      def path
        "tmp/#{filename}"
      end

      def generate_data(monthly_monitoring)
        generator.generate_data(monthly_monitoring).map do |data|
          format_data(data)
        end.join("\n")
      end

      def format_data(data)
        formatter.new(data).to_s
      end
    end

    class MonthlyRegulatoryActGenerator
      def self.generate_data(monthly_monitoring)
        RegulatoryAct.trading_or_price_registration.order(:act_number).map do |regulatory_act|
          {
            cod_orgao: monthly_monitoring.prefecture.organ_code,
            tipo_decreto: regulatory_act.regulatory_act_type_kind,
            nro_decreto_municipal: regulatory_act.act_number,
            data_decreto_municipal: regulatory_act.creation_date,
            data_publicacao_decreto_municipal: regulatory_act.publication_date
          }
        end
      end
    end

    class MonthlyRegulatoryActFormatter
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
  end
end
