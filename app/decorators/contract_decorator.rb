class ContractDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper

  attr_header :contract_number, :creditor,:start_date, :end_date, :contract_type,
              :purchasing_unit, :year,:link => [:contract_number, :creditor]



  def all_pledges_total_value
    return number_to_currency super if component.persisted? && super
    number_to_currency 0.0
  end

  def contract_value
    number_with_precision super if super
  end
end
