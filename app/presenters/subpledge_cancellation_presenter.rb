class SubpledgeCancellationPresenter < Presenter::Proxy
  def emission_date
    helpers.l object.emission_date if object.emission_date
  end

  def pledge_value
    helpers.number_with_precision object.pledge_value if object.pledge_value
  end

  def subpledge_balance
    helpers.number_with_precision object.subpledge_balance if object.subpledge_balance
  end

  def subpledge_expiration_balance
    helpers.number_with_precision object.subpledge_expiration_balance if object.subpledge_expiration_balance
  end
end
