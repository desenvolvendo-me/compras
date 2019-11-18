class ContractDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper

  attr_header :contract_number, :year, :publication_date

  def all_pledges_total_value
    return number_to_currency super if component.persisted? && super
    number_to_currency 0.0
  end

  def contract_value
    number_with_precision super if super
  end
end
