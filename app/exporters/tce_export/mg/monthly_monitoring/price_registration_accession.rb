module TceExport::MG
  module MonthlyMonitoring
    class PriceRegistrationAccessionDataGenerator < DataGeneratorBase
      def generate_data
        [{ }]
      end
    end

    class PriceRegistrationAccessionGenerator < GeneratorBase
      acronym 'REGADESAO'

      formats :format_data

      private

      def format_data(data)
        lines << ''
      end
    end
  end
end
