class SupplyRequestDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :creditor, :authorization_date, :licitation_process, :supply_request_status

  def creditor
    self.contract.nil? || self.contract.creditors.blank? || self.contract.creditors.first.person.nil? ? '' : self.contract.creditors.first.person.name
  end

  def modality_or_type_of_removal
    "#{component.modality_number} - #{component.modality_humanize || component.type_of_removal_humanize}"
  end

  def not_persisted_message
    t('purchase_solicitation.messages.not_persisted') unless persisted?
  end
end
