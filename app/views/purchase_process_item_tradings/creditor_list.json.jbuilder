json.array! @creditors do |creditor|
  json.amount        creditor.decorator.unit_price_of_proposal_by_item(resource)
  json.company_size  creditor.company_size.to_s
  json.creditor      creditor.to_s
  json.order         @creditors.index(creditor) + 1
  json.percent       '-'
  json.selected      creditor.decorator.selected?
end
