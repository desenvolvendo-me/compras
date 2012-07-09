class PledgeDecorator < Decorator
  attr_modal :id, :descriptor_id, :emission_date, :management_unit_id,
             :budget_allocation_id, :creditor_id

  def budget_allocation_real_amount
    helpers.number_with_precision super if super
  end

  def contract_signature_date
    helpers.l super if super
  end

  def emission_date
    helpers.l super.to_date if super
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

  def pledge_liquidations_sum
    helpers.number_with_precision super if super
  end

  def pledge_liquidations_sum_as_currency
    helpers.number_to_currency component.pledge_liquidations_sum if component.pledge_liquidations_sum
  end

  def value
    helpers.number_to_currency super if super
  end
end
