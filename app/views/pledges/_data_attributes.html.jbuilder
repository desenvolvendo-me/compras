builder resource, json do
  json.emission_date                       resource.emission_date
  json.pledge_value                        resource.value
  json.pledge_value_as_currency            resource.decorator.value
  json.pledge_liquidations_sum             resource.decorator.pledge_liquidations_sum
  json.pledge_liquidations_sum_as_currency resource.decorator.pledge_liquidations_sum_as_currency
  json.pledge_cancellations_sum            resource.decorator.pledge_cancellations_sum
  json.creditor_id                         resource.creditor_id
  json.creditor                            resource.creditor.to_s
  json.balance                             resource.decorator.balance
  json.balance_as_currency                 resource.decorator.balance_as_currency
  json.description                         resource.description
end
