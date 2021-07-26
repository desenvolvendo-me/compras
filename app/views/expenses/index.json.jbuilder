json.array!(collection) do |obj|
  json.id                obj.id
  json.value             obj.to_s
  json.label             obj.to_s
  json.organ             obj.organ
  json.purchasing_unit   obj.purchasing_unit
  json.project_activity  obj.project_activity
  json.nature_expense    obj.nature_expense
  json.resource_source   obj.resource_source
end
