builder resource, json do
  json.isCompany       resource.company?
  json.personable_type resource.personable_type
  json.name            resource.name
  json.cpf_cnpj        resource.cpf_cnpj
  json.modal_info_url  "/people/#{resource.id}.js"
end
