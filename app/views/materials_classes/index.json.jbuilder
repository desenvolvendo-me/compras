json.array!(collection) do |json, obj|
  json.id           obj.id
  json.value        obj.decorator.masked_to_s
  json.label        obj.decorator.masked_to_s
  json.mask         obj.mask
  json.child_mask   obj.decorator.child_mask
  json.filled_mask  obj.decorator.filled_masked_number
  json.class_number obj.class_number
end
