builder resource, json do
  json.licitation_number                        resource.licitation_number
  json.envelope_delivery_date                   resource.envelope_delivery_date
  json.envelope_delivery_time                   resource.decorator.envelope_delivery_time
  json.envelope_opening_date                    resource.envelope_opening_date
  json.envelope_opening_time                    resource.decorator.envelope_opening_time
  json.modality_humanize                        resource.decorator.modality_humanize
  json.advice_number                            resource.decorator.advice_number
  json.process_date                             resource.process_date
  json.administrative_process_modality_humanize resource.administrative_process_modality_humanize
  json.administrative_process_description       resource.administrative_process_description
  json.administrative_process                   resource.administrative_process.to_s
  json.summarized_object                        resource.administrative_process_summarized_object

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
