class PledgeDecorator < Decorator
  attr_modal :id, :entity_id, :year, :emission_date, :management_unit_id,
             :budget_allocation_id, :provider_id

  def budget_allocation_real_amount
    helpers.number_with_precision component.budget_allocation_real_amount
  end

  def reserve_fund_value
    helpers.number_with_precision component.reserve_fund_value
  end

  def balance
    helpers.number_with_precision component.balance
  end

  def balance_as_currency
    helpers.number_to_currency component.balance
  end

  def pledge_cancellations_sum
    helpers.number_to_currency super
  end

  def liquidation_value
    helpers.number_with_precision super if super
  end

  def liquidation_value_as_currency
    helpers.number_to_currency component.liquidation_value if component.liquidation_value
  end

  def value
    helpers.number_to_currency component.value if component.value
  end
end
