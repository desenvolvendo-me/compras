builder resource, json do
  json.description resource.description
  json.category    resource.category_humanize
  json.status      resource.status_humanize
end
