json.array!(collection) do |json, obj|
  json.id              obj.id
  json.value           obj.to_s
  json.label           obj.to_s
  json.personable_type obj.personable_type_humanize
  json.company_size    obj.company_size.to_s
  json.company_size_id obj.company_size.try(:id)
  json.is_company      obj.company?
  json.person_email    obj.person_email
  json.email           obj.email

  json.representatives obj.representatives do |json, representative|
    json.id   representative.id
    json.name representative.to_s
  end
end
