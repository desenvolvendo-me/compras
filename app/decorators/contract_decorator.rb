class ContractDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def all_pledges_total_value
    number_to_currency super if super
  end
end
