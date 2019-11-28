builder resource, json do
  json.purchase_form  resource.to_s
  json.expense        resource.expense
end