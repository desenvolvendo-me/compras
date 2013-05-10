require 'zip/zip'
module TceExport::MG
  module MonthlyMonitoring
    def self.generate_zip_file(monthly_monitoring)
      ZipFileGenerator.new(monthly_monitoring).generate_zip_file
    end

    class ZipFileGenerator
      def initialize(monthly_monitoring)
        @monthly_monitoring = monthly_monitoring
        @prefecture = monthly_monitoring.prefecture
        @date = monthly_monitoring.date
        @city_code = monthly_monitoring.city_code
      end

      def generate_zip_file
        csv_files = csv_classes.map { |csv_class| csv_class.generate_file(monthly_monitoring) }

        FileUtils.rm_f(zipfile_name)

        Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
          csv_files.each do |csv_filename|
            zipfile.add(csv_filename, 'tmp/' + csv_filename)
          end
        end

        zipfile_name
      end

      private

      attr_reader :prefecture, :date, :city_code, :monthly_monitoring

      def csv_classes
        MonthlyMonitoringFiles.list.map do |file|
          self.class.module_eval(file.classify).new
        end
      end

      def zipfile_name
        "tmp/AM_#{city_code}_#{prefecture_code}_#{filename_date}.zip"
      end

      def prefecture_code
        prefecture.organ_code
      end

      def filename_date
        date.strftime('%m_%Y')
      end
    end
  end
end
