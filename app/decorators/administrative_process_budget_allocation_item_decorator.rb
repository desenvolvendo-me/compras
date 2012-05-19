class AdministrativeProcessBudgetAllocationItemDecorator < Decorator
  attr_modal :material, :quantity, :unit_price

  def total_price
    helpers.number_to_currency component.total_price if component.total_price
  end
end
