json.array!(collection) do |obj|
  json.id       obj.id
  json.value    obj.to_s
  json.billing  obj.billing
  json.label    obj.to_s
  json.to_s     obj.to_s
end
