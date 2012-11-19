builder resource, json do
  json.material   resource.material.to_s
  json.quantity   resource.quantity
  json.unit_price resource.unit_price
end
