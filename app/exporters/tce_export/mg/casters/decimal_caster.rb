module TceExport::MG::Casters
  module DecimalCaster
    extend Validators

    def self.call(value, options)
      validate_blank(value, options)

      localized_value = I18n::Alchemy::NumericParser.localize(value)

      validate_length(localized_value, options)

      localized_value.nil? ? " " : localized_value.gsub(/\D/, "")
    end
  end
end
