class DirectPurchaseDecorator < Decorator
  attr_modal :year, :date, :modality

  attr_data 'id' => :id, 'name' => :to_s

  def total_allocations_items_value
    helpers.number_with_precision component.total_allocations_items_value
  end
end
