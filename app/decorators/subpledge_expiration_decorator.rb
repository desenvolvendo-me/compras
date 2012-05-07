class SubpledgeExpirationDecorator < Decorator
  def balance
    helpers.number_with_precision(component.balance) if component.balance
  end
end
