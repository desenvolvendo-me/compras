builder resource, json do
  json.isCompany                    resource.company?
  json.personable_type              resource.personable_type
  json.name                         resource.name
  json.identity_document            resource.identity_document
  json.modal_info_url               person_path(resource.id, :format => :js)
  json.companySize                  resource.company_size.to_s
  json.legalNature                  resource.legal_nature.to_s
  json.chooseSimple                 resource.choose_simple
  json.commercialRegistrationNumber resource.commercial_registration_number
  json.commercialRegistrationDate   resource.decorator.commercial_registration_date
end
