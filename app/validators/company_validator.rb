class CompanyValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    if !value.personable.is_a?(Company) && !value.personable.is_a?(Unico::Company)
      record.errors.add(attribute, :company_required)
    end
  end
end
