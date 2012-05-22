builder resource, json do
  json.emission_date               resource.decorator.emission_date
  json.pledge_value                resource.decorator.pledge_value
  json.pledge_provider             resource.pledge_provider.to_s
  json.pledge                      resource.pledge.to_s
  json.pledge_id                   resource.pledge_id
  json.balance                     resource.decorator.balance
  json.subpledge_cancellations_sum resource.decorator.subpledge_cancellations_sum
  json.subpledge_value             resource.decorator.value
  json.balance_as_currency         resource.decorator.balance_as_currency

  json.expirations resource.subpledge_expirations do |json, expiration|
    json.number          expiration.number
    json.expiration_date expiration.decorator.expiration_date
    json.value           expiration.decorator.value
    json.balance         expiration.decorator.balance
    json.canceled_value  expiration.decorator.canceled_value
  end
end
