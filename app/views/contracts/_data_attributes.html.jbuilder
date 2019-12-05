builder resource, json do
  json.signature_date resource.signature_date
  json.creditor resource.creditors.blank? || resource.creditors.first.person.nil? ? '' : resource.creditors.first.person.name
end
