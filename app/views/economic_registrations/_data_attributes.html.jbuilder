builder resource, json do
  json.person_id resource.person_id
  json.person    resource.person.to_s
end
