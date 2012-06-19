class BudgetAllocationDecorator < Decorator
  attr_modal :year, :description, :code

  def summary
    component.description if component.description
  end

  def real_amount
    helpers.number_with_precision(super) if super
  end

  def reserved_value
    helpers.number_with_precision(super) if super
  end
end
