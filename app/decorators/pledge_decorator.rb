class PledgeDecorator < Decorator
  attr_modal :id, :entity_id, :year, :emission_date, :management_unit_id,
             :budget_allocation_id, :provider_id

  def budget_allocation_real_amount
    helpers.number_with_precision component.budget_allocation_real_amount
  end

  def reserve_fund_value
    helpers.number_with_precision component.reserve_fund_value
  end

  def balance
    helpers.number_with_precision component.balance
  end

  def pledge_parcels_as_json
    component.pledge_parcels.map { |pledge_parcel|
      pledge_parcel.decorator.to_hash
    }.to_json
  end
end
