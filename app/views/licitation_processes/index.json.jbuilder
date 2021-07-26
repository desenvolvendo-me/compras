json.array!(collection) do |obj|
  json.id     obj.id
  json.value  obj.to_s
  json.label  obj.to_s
  json.to_s   obj.to_s
  json.contract_guarantees             obj.contract_guarantees
  json.contract_guarantees_humanize    obj.contract_guarantees_humanize
  json.description                     obj.description
  json.envelope_delivery_date          obj.envelope_delivery_date
  json.envelope_delivery_time          obj.decorator.envelope_delivery_time
  json.execution_type                  obj.execution_type
  json.execution_type_humanize         obj.execution_type_humanize
  json.description                     obj.description
  json.judgment_form                   obj.judgment_form_kind
  json.judgment_form_humanize          obj.judgment_form.kind_humanize
  json.modality_humanize               obj.modality_humanize.to_s
  json.modality_or_type_of_removal     obj.modality_or_type_of_removal
  json.process_date                    obj.process_date
  json.proposal_envelope_opening_date  obj.proposal_envelope_opening_date
  json.proposal_envelope_opening_time  obj.decorator.proposal_envelope_opening_time
  json.budget_allocations_ids          obj.budget_allocations_ids

  json.creditors obj.licitation_process_ratification_creditors do |creditor|
    next if obj.contracts.any?{|x| x.creditor_id == creditor.id}
    json.id               creditor.id
    json.name             creditor.to_s
  end.delete_if(&:empty?)
end
