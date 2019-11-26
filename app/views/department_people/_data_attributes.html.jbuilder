builder resource, json do
  json.deparment  resource.department.to_s
  json.user  resource.user.to_s
end