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
end
