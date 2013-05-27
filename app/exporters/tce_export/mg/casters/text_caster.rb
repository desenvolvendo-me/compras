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

      value = value.rjust(options[:size], rjust) if rjust
      value = value.ljust(options[:size], ljust) if ljust

      value.nil? ? " " : value
    end
  end
end
