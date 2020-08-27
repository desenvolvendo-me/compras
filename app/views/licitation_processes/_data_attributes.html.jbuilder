builder resource, json do
  json.contract_guarantees             resource.contract_guarantees
  json.contract_guarantees_humanize    resource.contract_guarantees_humanize
  json.description                     resource.description
  json.envelope_delivery_date          resource.envelope_delivery_date
  json.envelope_delivery_time          resource.decorator.envelope_delivery_time
  json.execution_type                  resource.execution_type
  json.execution_type_humanize         resource.execution_type_humanize
  json.modality_humanize               resource.modality_humanize.to_s
  json.modality_or_type_of_removal     resource.modality_or_type_of_removal
  json.process_date                    resource.process_date
  json.proposal_envelope_opening_date  resource.proposal_envelope_opening_date
  json.proposal_envelope_opening_time  resource.decorator.proposal_envelope_opening_time
  json.budget_allocations_ids          resource.budget_allocations_ids

  if resource.price_registration
    json.value   resource.to_s + " / Processo de Registro de Preço"
  else
    json.value   resource.to_s
  end
  json.items resource.items do |item|
    json.id                   item.id
    json.material_id          item.material_id
    json.material_description item.material.to_s
    json.lot                  item.lot
    json.reference_unit       item.reference_unit
    json.quantity             item.decorator.quantity
    json.unit_price           item.decorator.unit_price
    json.detailed_description item.material ? item.material.detailed_description : nil
  end

  json.creditors resource.licitation_process_ratification_creditors do |creditor|
    json.id                   creditor.id
    json.name             creditor.to_s
  end
end
