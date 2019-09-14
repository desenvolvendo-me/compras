builder resource, json do
  json.deparment  resource.department.to_s
  json.person  resource.person.to_s
end