class AdministrativeProcessBudgetAllocationItemDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def total_price
    number_to_currency super if super
  end

  def unit_price
    number_with_precision super if super
  end

  def unit_price_by_bidder(bidder)
    number_with_precision super if super
  end

  def total_value_by_bidder(bidder)
    number_with_precision super if super
  end

  def quantity
    number_with_precision super if super
  end

  def disable_creditor?
    !direct_purchase?
  end

  def hidden_creditor
    'hidden' unless direct_purchase?
  end
end
