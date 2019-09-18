json.array!(collection) do |obj|
  json.id           obj.id
  json.value        obj.to_s
  json.label        obj.to_s
  json.number       obj.number
  json.budget_allocation       obj.budget_allocation
end
