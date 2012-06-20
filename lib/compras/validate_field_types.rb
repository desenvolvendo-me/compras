module Compras
  module ValidateFieldTypes
    protected

    def value_is_integer?
      field_type == FieldType::INTEGER
    end

    def value_is_decimal?
      field_type == FieldType::DECIMAL
    end

    def parse_decimal
      return value if value.is_a?(Numeric)

      self.value = value.to_s.gsub(separator, '.')
    end

    def separator
      I18n::Alchemy::NumericParser.send(:separator)
    end
  end
end
