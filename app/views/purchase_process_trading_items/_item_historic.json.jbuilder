json.historic do
  json.array! @historic do |bid|
    json.partial! 'purchase_process_trading_bids/show', resource: bid
  end
end
