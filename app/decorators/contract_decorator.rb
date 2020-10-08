class ContractDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper

  attr_header :contract_number, :creditor, :type_contract,:year, :start_date, :end_date, :contract_type,
              :purchasing_unit, :status, :link => [:contract_number, :creditor]



  def all_pledges_total_value
    return number_to_currency super if component.persisted? && super
    number_to_currency 0.0
  end

  def contract_value
    number_with_precision super if super
  end

  def contract_or_minute
    if type_contract == ContractMinute::MINUTE
      "ATA"
    else
      "Contrato"
    end
  end

  def contract_or_minute_report
    if type_contract == ContractMinute::MINUTE
      "da ata"
    else
      "do Contrato"
    end
  end

  def publication_date
    I18n.l super if super
  end

  def start_date
    I18n.l super if super
  end

  def end_date
    I18n.l super if super
  end

end
