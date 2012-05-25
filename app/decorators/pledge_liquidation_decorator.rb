class PledgeLiquidationDecorator < Decorator
  def emission_date
    helpers.l(component.emission_date) if component.emission_date
  end

  def expiration_date
    helpers.l(component.expiration_date) if component.expiration_date
  end

  def balance
    helpers.number_with_precision(component.balance) if component.balance
  end

  def pledge_balance
    helpers.number_to_currency super if super
  end

  def pledge_value
    helpers.number_to_currency super if super
  end

  def pledge_liquidations_sum
    helpers.number_to_currency super if super
  end
end
