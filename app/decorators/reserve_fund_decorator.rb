class ReserveFundDecorator < Decorator
  attr_modal :licitation_modality_id, :provider_id, :status
  attr_modal :entity_id, :year, :budget_allocation_id, :reserve_allocation_type_id

  def budget_allocation_amount
    helpers.number_with_precision component.budget_allocation_amount
  end
end
