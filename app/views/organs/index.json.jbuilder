json.array!(collection) do |obj|
  json.id     obj.id
  json.value  obj.name
  json.label  obj.name
  json.to_s   obj.to_s
end
