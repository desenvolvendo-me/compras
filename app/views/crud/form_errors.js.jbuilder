if resource.errors
  json.errors Hash[resource.errors.each{ |key, value| [ key, value ] }]
end
