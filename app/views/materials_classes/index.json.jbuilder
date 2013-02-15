json.array!(collection) do |json, obj|
  json.id         obj.decorator.parent_class_number_masked
  json.value      obj.decorator.masked_to_s
  json.label      obj.decorator.masked_to_s
  json.mask       obj.mask
  json.child_mask obj.decorator.child_mask
  json.parent_class_number_masked obj.decorator.parent_class_number_masked
end
