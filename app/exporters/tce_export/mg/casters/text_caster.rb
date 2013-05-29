#encoding: utf-8
module TceExport::MG::Casters
  module TextCaster
    extend Validators

    def self.call(value, options)
      validate_blank(value, options)
      validate_length(value, options)
      validate_multiple_lenght(value, options)

      rjust = options.fetch(:rjust, nil)
      ljust = options.fetch(:ljust, nil)
      upcase = options.fetch(:upcase, false)

      return " " if value.nil?

      value = value.rjust(options[:size], rjust) if rjust
      value = value.ljust(options[:size], ljust) if ljust
      value = value.to_s.upcase if upcase

      value
    end
  end
end
