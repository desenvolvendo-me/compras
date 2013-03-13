builder resource, json do
  json.email          resource.email
  json.person_email   resource.person_email
  json.login          resource.login
  json.modal_info_url modal_info_link(resource)
end
