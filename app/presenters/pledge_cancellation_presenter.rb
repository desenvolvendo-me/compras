class PledgeCancellationPresenter < Presenter::Proxy
  def emission_date
    helpers.l(object.emission_date) if object.emission_date
  end

  def pledge_value
    helpers.number_with_precision(object.pledge_value) if object.pledge_value
  end

  def expiration_date
    helpers.l(object.expiration_date) if object.expiration_date
  end

  def balance
    helpers.number_with_precision(object.balance) if object.balance
  end
end
