if resource.errors
  json.errors Hash[resource.errors.each{ |key, value| [ key, value ] }]
end

json.id       resource.id
json.value    resource.to_s
json.label    resource.to_s
