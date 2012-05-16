builder resource, json do
  json.expiration_date         resource.expiration_date
  json.pledge_expiration_value resource.value
  json.balance                 resource.decorator.balance
  json.pledge_id               resource.pledge_id
  json.pledge                  resource.pledge.to_s
  json.emission_date           resource.decorator.emission_date
  json.pledge_value            resource.decorator.pledge_value
  json.modal_info_url          pledge_parcel_path(resource)
  json.pledge_description      resource.pledge_description
end
