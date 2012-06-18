class CompanyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    if !value.personable.is_a?(Company)
      record.errors.add(attribute, :company_required)
    end
  end
end
