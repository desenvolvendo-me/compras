# encoding: utf-8
class AdministrativeProcessPresenter < Presenter::Proxy
  attr_modal :year, :process, :protocol, :budget_unit_id

  attr_data 'budget-unit' => :budget_unit, 'modality' => :modality
  attr_data 'modality-humanize' => :modality_humanize, 'item' => :item
  attr_data 'object-type' => :object_type_humanize, 'judgment-form' => :judgment_form
  attr_data 'description' => :description, 'responsible' => :responsible

  def value_estimated
    helpers.number_to_currency(object.value_estimated)
  end

  def total_allocations_value
    helpers.number_with_precision(object.total_allocations_value)
  end

  def date
    helpers.l object.date
  end
end
