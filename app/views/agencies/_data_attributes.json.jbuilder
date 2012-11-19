builder resource, json do
  json.number  resource.number
  json.digit   resource.digit
  json.bank    resource.bank.to_s
  json.bank_id resource.bank_id
end
