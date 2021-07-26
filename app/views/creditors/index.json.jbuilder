json.array!(collection) do |obj|
  json.id                       obj.id
  json.value                    obj.to_s
  json.label                    obj.to_s
  json.personable_type          obj.personable_type_humanize
  json.company_size             obj.company_size.to_s
  json.company_size_id          obj.company_size.try(:id)
  json.is_company               obj.company?
  json.person_email             obj.person_email
  json.email                    obj.email
  json.creditor_representative  obj.creditor_representative
end
