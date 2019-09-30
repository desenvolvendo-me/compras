builder resource, json do
  json.demand_batch  resource.demand_batch.to_s
  json.material  resource.material.to_s
end
