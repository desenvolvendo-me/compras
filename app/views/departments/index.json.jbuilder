json.array!(collection) do |obj|
  json.id                       obj.id
  json.value                    obj.to_s
  json.label                    obj.to_s
  json.masked_number            obj.masked_number
  json.parent_id                obj.parent_id
  json.department_people_size   obj.department_people.count
  json.first_department_person  obj.department_people.first
end
