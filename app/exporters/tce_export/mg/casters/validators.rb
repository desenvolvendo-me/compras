#encoding: utf-8
module TceExport::MG::Casters
  module Validators
    def validate_blank(value, options)
      if value.blank? && options[:required]
        generator = options[:generator]
        generator.add_error "#{options[:attribute]} não pode ficar em branco."
      end
    end

    def validate_length(value, options)
      if value && value.to_s.length > options.fetch(:size, INFINITY)
        generator = options[:generator]
        generator.add_error "#{options[:attribute]} muito longo."
      end
    end

    def validate_multiple_lenght(value, options)
      return unless options[:multiple_size]

      if value && !options[:multiple_size].include?(value.to_s.length)
        generator = options[:generator]
        generator.add_error "#{options[:attribute]} com tamanho errado."
      end
    end
  end
end
