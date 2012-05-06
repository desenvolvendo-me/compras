class PledgeParcelPresenter < Presenter::Proxy
  attr_modal :pledge_id, :value, :number

  def emission_date
    helpers.l(object.emission_date) if object.emission_date
  end

  def pledge_value
    helpers.number_with_precision(object.pledge_value) if object.pledge_value
  end

  def balance
    helpers.number_with_precision(object.balance) if object.balance
  end

  def value
    helpers.number_to_currency(object.value) if object.value
  end

  def balance_as_currency
    helpers.number_to_currency(object.balance) if object.balance
  end

  def canceled_value
    helpers.number_to_currency(object.canceled_value) if object.canceled_value
  end

  def liquidations_value
    helpers.number_to_currency(object.liquidations_value) if object.liquidations_value
  end

  def canceled_liquidations_value
    helpers.number_to_currency(object.canceled_liquidations_value) if object.canceled_liquidations_value
  end

  def to_hash
    {
      'number' => number,
      'expiration_date' => expiration_date,
      'value' => value,
      'balance' => balance_as_currency
    }
  end
end
