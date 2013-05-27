class ContractDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header
  include ActionView::Helpers::NumberHelper

  attr_header :contract_number, :year, :publication_date

  def all_pledges_total_value
    number_to_currency super if super
  end
end
