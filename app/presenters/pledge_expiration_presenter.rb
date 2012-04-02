class PledgeExpirationPresenter < Presenter::Proxy
  def emission_date
    helpers.l(object.emission_date) if object.emission_date
  end

  def pledge_value
    helpers.number_with_precision(object.pledge_value) if object.pledge_value
  end
end
