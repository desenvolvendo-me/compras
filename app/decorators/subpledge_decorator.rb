class SubpledgeDecorator < Decorator
  attr_modal :entity_id, :year, :pledge_id, :provider_id, :number, :date,
             :value, :process_number, :description

  def emission_date
    helpers.l component.emission_date if component.emission_date
  end

  def pledge_value
    helpers.number_with_precision component.pledge_value if component.pledge_value
  end

  def pledge_balance
    helpers.number_with_precision component.pledge_balance if component.pledge_balance
  end

  def balance
    helpers.number_with_precision component.balance if component.balance
  end
end
