class SupplyRequestDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  if @gestor
    attr_header :number,:user,:creditor,:department,:value,:authorization_date, :licitation_process, :status_last_attendance
  else
    attr_header :number,:user,:creditor,:authorization_date, :licitation_process, :status_last_attendance
  end

  def creditor
    self.contract.nil? || self.contract.creditors.blank? || self.contract.creditors.first.person.nil? ? '' : self.contract.creditors.first.person.name
  end

  def value
    number_with_precision self.get_value
  end

  def modality_or_type_of_removal
    "#{component.modality_number} - #{component.modality_humanize || component.type_of_removal_humanize}"
  end

  def not_persisted_message
    t('purchase_solicitation.messages.not_persisted') unless persisted?
  end

  def status_last_attendance
    attendances = component.supply_request_attendances
    if attendances.any?
      SupplyRequestServiceStatus.t(attendances.last.service_status)
    end
  end
end
