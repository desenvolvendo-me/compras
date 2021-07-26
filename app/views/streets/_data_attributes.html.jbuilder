builder resource, json do
  json.city_id resource.city_id
  json.city    resource.city.to_s
end
