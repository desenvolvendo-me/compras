builder resource, json do
  json.isCompany      resource.company?
  json.modal_info_url "/people/#{resource.id}.js"
end
