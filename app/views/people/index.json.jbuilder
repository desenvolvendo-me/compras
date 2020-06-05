json.array!(collection) do |obj|
  json.id              obj.id
  json.value           obj.to_s
  json.label           "#{obj.identity_document} - #{obj.to_s}"
end
