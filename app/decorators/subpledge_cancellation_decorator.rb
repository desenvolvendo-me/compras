class SubpledgeCancellationDecorator < Decorator
  def emission_date
    helpers.l component.emission_date if component.emission_date
  end

  def pledge_value
    helpers.number_with_precision component.pledge_value if component.pledge_value
  end

  def subpledge_balance
    helpers.number_with_precision component.subpledge_balance if component.subpledge_balance
  end

  def subpledge_expiration_balance
    helpers.number_with_precision component.subpledge_expiration_balance if component.subpledge_expiration_balance
  end
end
