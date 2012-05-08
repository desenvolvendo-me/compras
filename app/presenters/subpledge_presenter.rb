class SubpledgePresenter < Presenter::Proxy
  attr_modal :entity_id, :pledge_id, :provider_id, :year, :number, :date, :value, :process_number

  def emission_date
    helpers.l object.emission_date if object.emission_date
  end

  def pledge_value
    helpers.number_with_precision object.pledge_value if object.pledge_value
  end

  def pledge_balance
    helpers.number_with_precision object.pledge_balance if object.pledge_balance
  end

  def balance
    helpers.number_with_precision object.balance if object.balance
  end
end
