builder resource, json do
  json.regulatory_act_type resource.regulatory_act_type
  json.regulatory_act_type_humanize resource.regulatory_act_type_humanize
  json.creation_date       resource.creation_date
  json.publication_date    resource.publication_date
  json.end_date            resource.end_date
  json.vigor_date          resource.vigor_date
  json.modal_info_url      modal_info_link(resource)
end
