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
        @only_files = monthly_monitoring.only_files
      end

      def generate_zip_file
        errors = []

        generators = generator_classes.map do |generator|
          generator_file = generator.generate_file
          errors = errors + generator.errors

          generator_file
        end

        unless errors.empty?
          monthly_monitoring.set_errors(errors.join("\n"))
        end

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
        csv_files.map do |file|
          self.class.module_eval("#{file.classify}Generator").new(monthly_monitoring)
        end
      end

      def csv_files
        if @only_files.present?
          reject_csv_file_class_injection @only_files
          @only_files
        else
          MonthlyMonitoringFiles.list
        end
      end

      def reject_csv_file_class_injection insecure_files
        not_allowed_files = insecure_files - MonthlyMonitoringFiles.list
        raise "Invalid csv files: #{not_allowed_files.join(', ')}" if not_allowed_files.present?
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

      def errors
        @errors ||= []
      end

      def add_error(error)
        errors << "#{error_header} - #{error}"
      end

      def add_error_description(description)
        return unless description

        errors << "#{description}\n"
      end

      def lines
        @lines ||= []
      end

      def error_header
        "#{acronym} [linha: #{lines.size + 1}]"
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
        @lines = []
        @errors = []

        begin
          data_generator.generate_data.each do |data|
            formats.each do |format|
              send(format, data)
            end
          end
        rescue Exception => e
          add_error "gerou erro interno!"

          if Rails.env.development? || Rails.env.test?
            raise e
          else
            Raven.capture_exception(e)
          end
        end

        lines.compact.join("\n")
      end
    end

    class FormatterBase
      include Typecaster

      attr_reader :data

      def self.separator
        ";"
      end

      def initialize(data, generator = nil)
        @generator = generator
        @data = data

        super(data)
      end

      def error_description(attribute, error_type); end

      private

      def typecasted_attribute(options)
        options[:generator] = @generator
        options[:formatter] = self

        klass = options[:caster]
        klass.call(options[:value], options)
      end
    end
  end
end
