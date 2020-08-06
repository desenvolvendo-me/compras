class SupplyOrderDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :number_year, :creditor, :authorization_date, :licitation_process, :status

  def number_year
    "#{self.number}/#{self.year}"
  end

  def creditor
    self.contract&.creditor&.person&.name
  end

  def creditor_id
    self.contract&.creditor&.person.nil? ? '' : self.contract.creditor.id
  end

  def modality_or_type_of_removal
    "#{component.modality_number} - #{component.modality_humanize || component.type_of_removal_humanize}"
  end

  def status
    status = ''
    component.items.each do |item|
      qtd_solicited = item.quantity || 0
      qtd_supplied = qtd_solicited - item.supplied_invoices.sum(:quantity_supplied)
      if qtd_supplied == 0 && qtd_solicited != 0
        status = "Atendido"
      elsif qtd_supplied > 0 && qtd_solicited == qtd_supplied
        status= "Nenhum Solicitado"
      elsif qtd_supplied > 0
        status = "Atendido Parcialmente"
        break
      else
        status = "Em Aberto"
      end
    end

    status
  end
end
