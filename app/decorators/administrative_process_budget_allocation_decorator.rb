class AdministrativeProcessBudgetAllocationDecorator
  include Decore
  include Decore::Proxy
  include ActionView::Helpers::NumberHelper

  def id_or_mustache_variable
    component.id || "{{id}}"
  end

  def budget_allocation_id_or_mustache_variable
    component.budget_allocation_id || "{{budget_allocation_id}}"
  end

  def budget_allocation_or_mustache_variable
    component.budget_allocation || "{{description}}"
  end

  def budget_allocation_expense_nature_or_mustache_variable
    component.budget_allocation_expense_nature || "{{expenseNature}}"
  end

  def budget_allocation_amount_or_mustache_variable
    number_with_precision(component.budget_allocation_amount) || "{{amount}}"
  end

  def value_or_mustache_variable
    number_with_precision(component.value) || "{{value}}"
  end

  def total_items_value
    number_with_precision(super)
  end
end
