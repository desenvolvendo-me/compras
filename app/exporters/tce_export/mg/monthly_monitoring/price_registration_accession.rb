module TceExport::MG
  module MonthlyMonitoring
    class PriceRegistrationAccessionDataGenerator < DataGeneratorBase
      def generate_data
        [{ }]
      end
    end

    class PriceRegistrationAccessionFormatter
      include Typecaster

      output_separator ";"
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
