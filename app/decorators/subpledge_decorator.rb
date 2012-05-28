class SubpledgeDecorator < Decorator
  attr_modal :entity_id, :year, :pledge_id, :provider_id, :number, :date,
             :value, :process_number, :description

  def emission_date
    helpers.l component.emission_date if component.emission_date
  end

  def pledge_value
    helpers.number_with_precision component.pledge_value if component.pledge_value
  end

  def balance
    helpers.number_with_precision component.balance if component.balance
  end

  def balance_as_currency
    helpers.number_to_currency component.balance if component.balance
  end

  def subpledge_cancellations_sum
    helpers.number_to_currency super
  end

  def value
    helpers.number_to_currency super if super
  end

  def pledge_value_as_currency
    helpers.number_to_currency component.pledge_value if component.pledge_value
  end

  def pledge_balance
    helpers.number_to_currency super if super
  end
end
