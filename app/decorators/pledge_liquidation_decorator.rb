class PledgeLiquidationDecorator < Decorator
  def emission_date
    helpers.l super if super
  end

  def expiration_date
    helpers.l super if super
  end

  def balance
    helpers.number_with_precision super if super
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

  def pledge_cancellations_sum
    helpers.number_to_currency super if super
  end

  def parcels_sum
    helpers.number_with_precision super if super
  end

  def value
    helpers.number_to_currency super if super
  end
end
