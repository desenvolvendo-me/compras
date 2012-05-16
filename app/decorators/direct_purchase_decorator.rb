class DirectPurchaseDecorator < Decorator
  attr_modal :year, :date, :modality

  def total_allocations_items_value
    helpers.number_with_precision component.total_allocations_items_value
  end
end
