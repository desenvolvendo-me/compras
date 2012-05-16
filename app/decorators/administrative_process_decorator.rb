# encoding: utf-8
class AdministrativeProcessDecorator < Decorator
  attr_modal :year, :process, :protocol, :budget_unit_id

  def value_estimated
    helpers.number_to_currency(component.value_estimated)
  end

  def total_allocations_value
    helpers.number_with_precision(component.total_allocations_value)
  end
end
