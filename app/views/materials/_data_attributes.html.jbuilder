builder resource, json do
  json.code           resource.code
  json.description    resource.description
  json.reference_unit resource.reference_unit.to_s
  json.unit_price     resource.unit_price.to_s
end