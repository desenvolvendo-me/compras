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
        generators = generator_classes.map { |generator| generator.generate_file }

        FileUtils.rm_f(zipfile_name)

        Zip::ZipFile.open(zipfile_name, Zip::ZipFile::CREATE) do |zipfile|
          generators.each do |generator_filename|
            zipfile.add(generator_filename, 'tmp/' + generator_filename)
          end
        end

        zipfile_name
      end

      private

      attr_reader :prefecture, :date, :city_code, :monthly_monitoring

      def generator_classes
        MonthlyMonitoringFiles.list.map do |file|
          self.class.module_eval("#{file.classify}Generator").new(monthly_monitoring)
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

    class Base
      def initialize(monthly_monitoring)
        @monthly_monitoring = monthly_monitoring
      end

      private

      attr_reader :monthly_monitoring
    end

    class DataGeneratorBase < Base
      private

      def only_numbers(data)
        return unless data

        data.gsub(/\D/, '')
      end
    end

    class GeneratorBase < Base
      def self.generate_file(*args)
        new(*args).generate_file
      end

      def generate_file
        File.open(path, 'w', :encoding => 'ISO-8859-1') do |f|
          f.write(generate_data)
        end

        filename
      end

      private

      class_attribute :acronym_attr, :formats_attr

      def self.acronym(acronym)
        self.acronym_attr = acronym
      end

      def self.formatters(options = {})
        options.each do |formatter_name, formatter_class|
          class_eval %{
            private

            def #{formatter_name}
              #{formatter_class}
            end
          }
        end
      end

      def self.formats(*args)
        self.formats_attr = []

        args.each do |format|
          formats_attr << format
        end
      end

      def data_generator_class
        self.class.module_eval("#{generator_name}DataGenerator")
      end

      def generator_name
        self.class.name.gsub(/Generator$/, '')
      end

      def data_generator
        data_generator_class.new(monthly_monitoring)
      end

      def acronym
        self.class.acronym_attr
      end

      def formats
        self.class.formats_attr
      end

      def date
        monthly_monitoring.date
      end

      def prefecture
        monthly_monitoring.prefecture
      end

      def filename
        "#{acronym}.csv"
      end

      def path
        "tmp/#{filename}"
      end

      def generate_data
        begin
          data_generator.generate_data.map do |data|
            formats.map do |format|
              send(format, data)
            end.compact.join("\n")
          end.join("\n")
        rescue TceExport::MG::Exceptions::InvalidData => e
          raise e.class, "#{acronym} - #{e.message}"
        end
      end
    end
  end
end
