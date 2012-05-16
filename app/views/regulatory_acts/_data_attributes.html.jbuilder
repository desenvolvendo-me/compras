builder resource, json do
  json.regulatory_act_type resource.regulatory_act_type.to_s
  json.publication_date    resource.publication_date
  json.vigor_date          resource.vigor_date
end
