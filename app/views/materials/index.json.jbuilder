json.array!(collection) do |obj|
  json.id                   obj.id
  json.value                obj.to_s
  json.label                obj.to_s
  json.to_s                 obj.to_s
  json.reference_unit       obj.reference_unit.to_s
  json.detailed_description obj.detailed_description
  json.material_class       obj.material_class.to_s
end
