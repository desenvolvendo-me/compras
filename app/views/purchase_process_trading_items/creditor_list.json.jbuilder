json.array! @creditors do |creditor|
  json.amount              creditor.decorator.unit_price_of_proposal(resource.purchase_process_id, resource.item_or_lot)
  json.company_size        creditor.company_size.to_s
  json.creditor            creditor.to_s
  json.order               @creditors.index(creditor) + 1
  json.percent             '-'
  json.selected            creditor.decorator.selected?(resource.purchase_process_id, resource.item_or_lot)
  json.not_selected_class  creditor.decorator.not_selected_class(resource.purchase_process_id, resource.item_or_lot)

  if resource.creditor_winner.try(:id) == creditor.creditor_id
    json.status     'Vencedor'
  else
    json.status     resource.bids_historic.where(purchase_process_accreditation_creditor_id: creditor.id).try(:first).try(:status_humanize)
  end
end
