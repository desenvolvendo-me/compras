class RevenueAccountingPresenter < Presenter::Proxy
  def date(date_storage = ::Date)
    if object.persisted?
      created_at_or_default = object.created_at.to_date
    else
      created_at_or_default = date_storage.current
    end

    helpers.l created_at_or_default
  end
end
