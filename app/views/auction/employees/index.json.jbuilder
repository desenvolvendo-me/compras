json.array!(collection) do |obj|
  json.id            obj.id
  json.value         obj.to_s
  json.label         obj.to_s
  json.position      obj.try(:position).try(:to_s)
  json.registration  obj.registration
  json.to_s   obj.to_s
end
