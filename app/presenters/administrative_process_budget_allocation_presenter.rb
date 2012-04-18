class AdministrativeProcessBudgetAllocationPresenter < Presenter::Proxy
  def id_or_mustache_variable
    object.id || "{{id}}"
  end

  def budget_allocation_id_or_mustache_variable
    object.budget_allocation_id || "{{budget_allocation_id}}"
  end

  def budget_allocation_or_mustache_variable
    object.budget_allocation || "{{description}}"
  end

  def budget_allocation_expense_nature_or_mustache_variable
    object.budget_allocation_expense_nature || "{{expenseNature}}"
  end

  def budget_allocation_amount_or_mustache_variable
    helpers.number_with_precision(object.budget_allocation_amount) || "{{amount}}"
  end

  def value_or_mustache_variable
    helpers.number_with_precision(object.value) || "{{value}}"
  end

  def total_items_value
    helpers.number_with_precision(object.total_items_value)
  end
end
