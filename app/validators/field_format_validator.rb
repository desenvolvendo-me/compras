class FieldFormatValidator < ActiveModel::EachValidator
  # Validate record by a given field mask
  #
  #   record.field = Field.new(:mask => 'aaa')
  #   record.value = 'abc' # => valid
  #   record.value = '1bc' # => invalid
  #
  #   record.field = Field.new(:mask => '99a')
  #   record.value = '14b' # => valid
  #   record.valid = 'c4b' # => invalid
  def validate_each(record, attribute, value)
    record.errors.add(:value, :invalid) unless record.field.try(:match, value)
  end
end
