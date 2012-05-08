class SubpledgeExpirationPresenter < Presenter::Proxy
  def balance
    helpers.number_with_precision(object.balance) if object.balance
  end
end
