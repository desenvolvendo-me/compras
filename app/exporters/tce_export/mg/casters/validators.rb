module TceExport::MG::Casters
  module Validators
    def validate_blank(value, options)
      if value.blank? && options[:required]
        options[:error_type] = :required
        set_errors("#{options[:attribute]} não pode ficar em branco.", options)
      end
    end

    def validate_length(value, options)
      if value && value.to_s.length > options.fetch(:size, INFINITY)
        options[:error_type] = :size
        set_errors("#{options[:attribute]} muito longo.", options)
      end
    end

    def validate_multiple_lenght(value, options)
      return unless options[:multiple_size]

      if value && !options[:multiple_size].include?(value.to_s.length)
        options[:error_type] = :multiple_size
        set_errors("#{options[:attribute]} com tamanho errado.", options)
      end
    end

    private

    def set_errors(message, options = {})
      generator = options[:generator]
      formatter = options[:formatter]

      generator.add_error message
      generator.add_error_description formatter.error_description(options[:attribute], options[:error_type])
    end
  end
end
