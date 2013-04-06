json.array!(collection) do |json, obj|
  json.id              obj.id
  json.value           obj.to_s
  json.label           obj.to_s
  json.personable_type obj.personable_type_humanize
  json.company_size    obj.company_size.to_s
  json.company_size_id obj.company_size.try(:id)
end
