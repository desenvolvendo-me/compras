builder resource, json do
  json.description         resource.description
  json.purchasing_unit_id  resource.purchasing_unit_id
  json.purchasing_unit     resource.try(:purchasing_unit).try(:to_s)
end
