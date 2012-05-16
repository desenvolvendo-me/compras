builder resource, json do
  json.emission_date   resource.decorator.emission_date
  json.pledge_value    resource.decorator.pledge_value
  json.pledge_provider resource.pledge_provider.to_s
  json.pledge          resource.pledge.to_s
  json.pledge_id       resource.pledge_id
  json.balance         resource.decorator.balance
end
