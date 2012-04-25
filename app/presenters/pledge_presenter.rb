class PledgePresenter < Presenter::Proxy
  attr_modal :entity_id, :year, :emission_date

  def budget_allocation_real_amount
    helpers.number_with_precision object.budget_allocation_real_amount
  end

  def reserve_fund_value
    helpers.number_with_precision object.reserve_fund_value
  end

  def balance
    helpers.number_with_precision object.balance
  end
end
