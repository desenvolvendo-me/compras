class IndividualValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    if !value.personable.is_a?(Individual)
      record.errors.add(attribute, :individual_required)
    end
  end
end
