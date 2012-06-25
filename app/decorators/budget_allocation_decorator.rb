class BudgetAllocationDecorator < Decorator
  attr_modal :code, :descriptor_id, :description

  def real_amount
    helpers.number_with_precision(super) if super
  end

  def reserved_value
    helpers.number_with_precision(super) if super
  end
end
