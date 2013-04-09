json.array!(collection) do |json, obj|
  json.id                obj.id
  json.value             obj.to_s
  json.label             obj.to_s
  json.to_s              obj.to_s
  json.amount            obj.amount
  json.expense_nature    obj.expense_nature.to_s
  json.expense_nature_id obj.expense_nature_id
end
