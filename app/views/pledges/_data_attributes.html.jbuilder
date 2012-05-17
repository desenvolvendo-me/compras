builder resource, json do
  json.emission_date           resource.emission_date
  json.pledge_value            resource.value
  json.pledge_liquidations_sum resource.decorator.pledge_liquidations_sum
  json.provider_id             resource.provider_id
  json.provider                resource.provider.to_s
  json.balance                 resource.decorator.balance
  json.description             resource.description

  json.parcels resource.pledge_parcels do |json, parcel|
    json.number                      parcel.number
    json.expiration_date             parcel.decorator.expiration_date
    json.value                       parcel.decorator.value
    json.balance                     parcel.decorator.balance_as_currency
    json.liquidations_value          parcel.decorator.liquidations_value
    json.canceled_liquidations_value parcel.decorator.canceled_liquidations_value
    json.canceled_value              parcel.decorator.canceled_value
    json.liquidations_value          parcel.decorator.liquidations_value
  end
end
