class SupplyOrderDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :number_year, :creditor, :authorization_date, :licitation_process, :order_status

  def number_year
    "#{self.number}/#{self.year}"
  end

  def creditor
    self.contract.nil? || self.contract.creditors.blank? || self.contract.creditors.first.person.nil? ? '' : self.contract.creditors.first.person.name
  end

  def creditor_id
    self.contract.nil? || self.contract.creditors.blank? || self.contract.creditors.first.person.nil? ? '' : self.contract.creditors.first.id
  end

  def modality_or_type_of_removal
    "#{component.modality_number} - #{component.modality_humanize || component.type_of_removal_humanize}"
  end

  def order_status
    SupplyOrderStatus.t(component.order_status)
  end
end
