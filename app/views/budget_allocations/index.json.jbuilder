json.array!(collection) do |obj|
  json.id                obj.id
  json.value             obj.autocomplete_budget_allocation
  json.label             obj.autocomplete_budget_allocation
  json.balance           obj.balance.to_f
  json.expense_nature    obj.expense_nature.to_s
  json.expense_nature_id obj.expense_nature_id
end
