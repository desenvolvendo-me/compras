builder resource, json do
  json.material                     resource.material.to_s
  json.quantity                     resource.quantity
  json.unit_price                   resource.unit_price
  json.lot                          resource.lot
  json.item_number                  resource.item_number
  json.additional_information       resource.additional_information
  json.ratification_item_unit_price number_with_precision resource.ratification_item_unit_price
end
