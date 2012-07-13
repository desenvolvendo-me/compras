builder resource, json do
  json.isCompany         resource.company?
  json.personable_type   resource.personable_type
  json.name              resource.name
  json.identity_document resource.identity_document
  json.modal_info_url    "/people/#{resource.id}.js"
  if resource.company?
    json.companySize     resource.company_size.to_s
    json.legalNature     resource.legal_nature.to_s
    json.chooseSimple    resource.choose_simple
  end
end
