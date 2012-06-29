class ContractDecorator < Decorator
  attr_modal :year, :contract_number, :sequential_number, :signature_date

  def pledges_total_value
    helpers.number_to_currency super if super
  end

  def modality
    modality_type = 'administrative_process_modality' if licitation_process.present?
    modality_type ||= 'direct_purchase_modality'

    helpers.t("enumerations.#{modality_type}.#{super}")
  end
end
