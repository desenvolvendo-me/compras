if resource
  json.accreditation_creditor              resource.accreditation_creditor.to_s
  json.accreditation_creditor_id           resource.purchase_process_accreditation_creditor_id
  json.creditor_company_size               resource.accreditation_creditor.company_size.to_s
  json.amount                              number_with_precision(resource.amount)
  json.amount_with_reduction               number_with_precision(resource.amount_with_reduction)
  json.id                                  resource.id
  json.item                                resource.item.to_s
  json.item_id                             resource.item.id
  json.lot                                 resource.decorator.lot
  json.number                              resource.number
  json.percent                             resource.decorator.percent
  json.round                               resource.round
  json.status                              resource.status_humanize
  json.errors                              resource.errors
end
