json.array!(collection) do |json, obj|
  json.id              obj.id
  json.value           obj.to_s
  json.label           obj.to_s
  json.to_s            obj.to_s
  json.reference_unit  obj.reference_unit.to_s
end
