class SubpledgeExpirationDecorator < Decorator
  def balance
    helpers.number_to_currency super
  end

  def canceled_value
    helpers.number_to_currency super
  end

  def value
    helpers.number_to_currency super if super
  end
end
