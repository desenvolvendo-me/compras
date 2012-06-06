class PledgeParcelDecorator < Decorator
  attr_modal :pledge_id, :value, :number

  def emission_date
    helpers.l(component.emission_date) if component.emission_date
  end

  def pledge_value
    helpers.number_with_precision(component.pledge_value) if component.pledge_value
  end

  def balance
    helpers.number_with_precision(component.balance) if component.balance
  end

  def value
    helpers.number_to_currency(component.value) if component.value
  end

  def balance_as_currency
    helpers.number_to_currency(component.balance) if component.balance
  end

  def canceled_value
    helpers.number_to_currency(component.canceled_value) if component.canceled_value
  end

  def liquidations_value
    helpers.number_to_currency(component.liquidations_value) if component.liquidations_value
  end

  def canceled_liquidations_value
    helpers.number_to_currency(component.canceled_liquidations_value) if component.canceled_liquidations_value
  end

  def subpledges_sum
    helpers.number_to_currency super if super
  end
end
