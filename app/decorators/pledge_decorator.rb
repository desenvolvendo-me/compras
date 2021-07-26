class PledgeDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TranslationHelper

  def budget_allocation_real_amount
    number_with_precision super if super
  end

  def contract_signature_date
    localize super if super
  end

  def emission_date
    localize super.to_date if super
  end

  def reserve_fund_value
    number_with_precision super if super
  end

  def pledge_parcels_sum
    number_with_precision super if super
  end

  def balance
    number_with_precision super if super
  end

  def balance_as_currency
    number_to_currency component.balance if component.balance
  end

  def pledge_cancellations_sum
    number_to_currency super if super
  end

  def pledge_liquidations_sum
    number_with_precision super if super
  end

  def pledge_liquidations_sum_as_currency
    number_to_currency component.pledge_liquidations_sum if component.pledge_liquidations_sum
  end

  def value
    number_to_currency super if super
  end
end
