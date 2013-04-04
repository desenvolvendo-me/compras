json.array!(collection) do |json, obj|
  json.id                obj.id
  json.value             obj.to_s
  json.label             obj.to_s
  json.amount            obj.amount.to_f
  json.expense_nature    obj.expense_nature.to_s
  json.expense_nature_id obj.expense_nature_id
end
