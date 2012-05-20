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

  def pledge_liquidations_sum
    helpers.number_with_precision(component.pledge_liquidations_sum) if component.pledge_liquidations_sum
  end
end
