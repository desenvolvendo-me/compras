# encoding: utf-8
class AdministrativeProcessDecorator < Decorator
  attr_modal :year, :process, :protocol, :budget_unit_id

  attr_data 'budget-unit' => :budget_unit, 'modality' => :modality
  attr_data 'modality-humanize' => :modality_humanize, 'item' => :item
  attr_data 'object-type-humanize' => :object_type_humanize, 'judgment-form' => :judgment_form
  attr_data 'description' => :description, 'responsible' => :responsible
  attr_data 'budget-allocations' => :budget_allocations_attr_data
  attr_data 'id' => :id, 'judgment-form-kind' => :judgment_form_kind
  attr_data 'object-type' => :object_type

  def value_estimated
    helpers.number_to_currency(component.value_estimated)
  end

  def total_allocations_value
    helpers.number_with_precision(component.total_allocations_value)
  end
end
