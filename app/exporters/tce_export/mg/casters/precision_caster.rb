module TceExport::MG::Casters
  module PrecisionCaster
    extend Validators
    extend ActionView::Helpers::NumberHelper

    def self.call(value, options)
      validate_blank(value, options)

      localized_value = number_with_precision(value,
                                              precision: options.fetch(:precision, 2),
                                              separator: ',')

      validate_length(localized_value, options)

      localized_value.nil? ? " " : localized_value
    end
  end
end

