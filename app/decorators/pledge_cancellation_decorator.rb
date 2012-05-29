class PledgeCancellationDecorator < Decorator
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

  def pledge_cancellations_sum
    helpers.number_to_currency super if super
  end
end
