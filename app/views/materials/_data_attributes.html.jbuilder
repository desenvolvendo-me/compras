builder resource, json do
  json.code           resource.code
  json.description    resource.description
  json.reference_unit resource.reference_unit.to_s
  json.quantity_unit  resource.quantity_unit
end