builder resource, json do
  json.signature_date    resource.signature_date
  json.creditor          resource.creditor.blank? || resource.creditor.person.nil? ? '' : resource.creditor.person.name
  json.creditor_id       resource.creditor.blank? || resource.creditor.person.nil? ? '' : resource.creditor.id
  json.type_contract     resource.type_contract
end
