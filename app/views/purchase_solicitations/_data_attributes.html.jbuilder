builder resource, json do
  json.purchase_solicitation  resource.to_s
  json.quantity_by_material   resource.decorator.quantity_by_material(params[:by_material_id])
end
