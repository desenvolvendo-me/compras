json.array!(collection) do |json, obj|
  json.id         obj.decorator.filled_masked_number(false)
  json.value      obj.decorator.masked_to_s
  json.label      obj.decorator.masked_to_s
  json.mask       obj.mask
  json.child_mask obj.decorator.child_mask
end
