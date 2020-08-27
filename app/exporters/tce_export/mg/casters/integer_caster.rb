module TceExport::MG::Casters
  module IntegerCaster
    extend Validators

    def self.call(value, options)
      validate_blank(value, options)
      validate_length(value.to_s, options)

      value.nil? ? " " : value.to_s.rjust(options.fetch(:min_size, 0), "0")
    end
  end
end
