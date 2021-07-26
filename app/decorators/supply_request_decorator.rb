class SupplyRequestDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  attr_header :number_year, :user, :creditor, :department, :value, :authorization_date, :licitation_process, :status_last_attendance

  def number_year
    "#{number}/#{year}"
  end

  def creditor
    self.contract&.creditor&.person&.name
  end

  def creditor_id
    self.contract&.creditor&.person.nil? ? '' : self.contract.creditor.id
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
