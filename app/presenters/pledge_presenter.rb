class PledgePresenter < Presenter::Proxy
  attr_modal :entity_id, :year, :emission_date, :management_unit_id,
             :budget_allocation_id, :creditor_id

  def budget_allocation_real_amount
    helpers.number_with_precision object.budget_allocation_real_amount
  end

  def reserve_fund_value
    helpers.number_with_precision object.reserve_fund_value
  end

  def balance
    helpers.number_with_precision object.balance
  end

  def pledge_parcels_as_json
    object.pledge_parcels.map { |pledge_parcel|
      pledge_parcel.presenter.to_hash
    }.to_json
  end
end
