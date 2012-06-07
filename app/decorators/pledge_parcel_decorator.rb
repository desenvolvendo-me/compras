class PledgeParcelDecorator < Decorator
  attr_modal :pledge_id, :value, :number

  def emission_date
    helpers.l super if super
  end

  def pledge_value
    helpers.number_with_precision super if super
  end

  def balance
    helpers.number_with_precision super if super
  end

  def value
    helpers.number_to_currency super if super
  end

  def balance_as_currency
    helpers.number_to_currency(component.balance) if component.balance
  end

  def canceled_value
    helpers.number_to_currency super if super
  end

  def liquidations_value
    helpers.number_to_currency super if super
  end

  def canceled_liquidations_value
    helpers.number_to_currency super if super
  end
end
