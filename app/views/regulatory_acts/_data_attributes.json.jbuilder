builder resource, json do
  json.regulatory_act_type resource.regulatory_act_type.to_s
  json.creation_date       resource.creation_date
  json.publication_date    resource.publication_date
  json.end_date            resource.end_date
  json.vigor_date          resource.vigor_date
  json.modal_info_url      regulatory_act_path(resource)
end
