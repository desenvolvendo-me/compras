class RangeSentenceValidator < ActiveModel::EachValidator
  # Validates whether the value of the specified attribute is of the correct form for RangeSentenceParser.
  #
  # Example:
  #
  #   class Parcel < ActiveRecord::Base
  #     validates :parcel_ids, :range_sentence => true
  #   end
  def validate_each(record, attribute, value)
    record.errors.add(attribute) unless RangeSentenceParser.new(value).valid?
  end
end
