builder resource, json do
  json.licitation_number            resource.licitation_number
  json.envelope_delivery_date       resource.envelope_delivery_date
  json.envelope_delivery_time       resource.decorator.envelope_delivery_time
  json.envelope_opening_date        resource.envelope_opening_date
  json.envelope_opening_time        resource.decorator.envelope_opening_time
  json.advice_number                resource.decorator.advice_number
  json.process_date                 resource.process_date
  json.modality_humanize            resource.modality_humanize.to_s
  json.description                  resource.description
  json.summarized_object            resource.summarized_object
  json.execution_type_humanize      resource.execution_type_humanize
  json.contract_guarantees_humanize resource.contract_guarantees_humanize


  json.items resource.items do |json, item|
    json.id                   item.id
    json.material_id          item.material_id
    json.material_description item.material.to_s
    json.reference_unit       item.reference_unit
    json.quantity             item.decorator.quantity
    json.unit_price           item.decorator.unit_price
    json.detailed_description item.material.detailed_description
  end
end
