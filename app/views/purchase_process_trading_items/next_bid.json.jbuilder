json.id                     resource.id
json.reduction_rate_value   resource.decorator.reduction_rate_value
json.reduction_rate_percent resource.decorator.reduction_rate_percent

json.lowest_bid do
  if @lowest_bid
    json.amount    number_with_precision(@lowest_bid.amount)
    json.creditor  @lowest_bid.accreditation_creditor.to_s
  end
end

json.next_bid do
  json.partial! 'purchase_process_trading_bids/show', resource: @next_bid
end

json.partial! 'item_historic'
