class PledgeDecorator < Decorator
  attr_modal :id, :entity_id, :year, :emission_date, :management_unit_id,
             :budget_allocation_id, :provider_id

  def budget_allocation_real_amount
    helpers.number_with_precision super if super
  end

  def reserve_fund_value
    helpers.number_with_precision super if super
  end

  def pledge_parcels_sum
    helpers.number_with_precision super if super
  end

  def balance
    helpers.number_with_precision super if super
  end

  def balance_as_currency
    helpers.number_to_currency component.balance if component.balance
  end

  def pledge_cancellations_sum
    helpers.number_to_currency super if super
  end

  def liquidation_value
    helpers.number_with_precision super if super
  end

  def subpledges_sum
    helpers.number_to_currency super if super
  end

  def liquidation_value_as_currency
    helpers.number_to_currency component.liquidation_value if component.liquidation_value
  end

  def value
    helpers.number_to_currency super
  end

  def pledge_liquidation_cancellations_sum
    helpers.number_to_currency super if super
  end

  def pledge_liquidations_sum
    helpers.number_to_currency super if super
  end
end
