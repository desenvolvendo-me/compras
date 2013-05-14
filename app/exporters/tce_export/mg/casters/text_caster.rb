#encoding: utf-8
module TceExport::MG::Casters
  module TextCaster
    extend Validators

    def self.call(value, options)
      validate_blank(value, options)
      validate_length(value, options)
      validate_multiple_lenght(value, options)

      value.nil? ? " " : value
    end
  end
end
