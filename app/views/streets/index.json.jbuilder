json.array!(collection) do |obj|
  json.id         obj.id
  json.value      obj.to_s
  json.label      obj.to_s
  json.to_s       obj.to_s
  json.city       obj.city
  json.state      obj.city&.state
  json.zip_code   obj.zip_code
  json.neighborhoods obj.neighborhoods do |neighborhood|
    json.id    neighborhood.id
    json.name  neighborhood.name
  end
end
