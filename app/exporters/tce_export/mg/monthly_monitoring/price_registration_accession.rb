module TceExport::MG
  module MonthlyMonitoring
    class PriceRegistrationAccessionDataGenerator < DataGeneratorBase
      def generate_data
        [{ foobar: '11' }]
      end

      private

      # def query
      #   RegulatoryAct.trading_or_price_registration.order(:act_number)
      # end
    end

    class PriceRegistrationAccessionFormatter
      include Typecaster

      output_separator ";"

      attribute :foobar, position: 0, size: 2, min_size: 2, required: true, caster: Casters::TextCaster
    end

    class PriceRegistrationAccessionGenerator < GeneratorBase
      acronym 'REGADESAO'

      formatters formatter: PriceRegistrationAccessionFormatter

      formats :format_data

      private

      def format_data(data)
        formatter.new(data).to_s
      end
    end
  end
end
