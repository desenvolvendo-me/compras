class AdditiveSolicitationsController < CrudController

  def margin
    quantity = params["quantity"].to_i
    value = params["value"].to_f
    material_id = params["material_id"]
    licitation_process_id = params["licitation_process_id"]

    additived_margen = AdditiveSolicitationItem.joins(:additive_solicitation).where("compras_additive_solicitations.licitation_process_id = #{licitation_process_id}").where("compras_additive_solicitation_items.material_id = #{material_id}").group("compras_additive_solicitation_items.material_id").select("SUM(compras_additive_solicitation_items.quantity * compras_additive_solicitation_items.value) AS total").first.total.to_i
    item = PurchaseProcessItem.where(licitation_process_id: licitation_process_id).where(material_id: material_id).first

    solicited_margen = quantity * value
    max_margen = item.quantity * item.unit_price.to_f
    margen = (((solicited_margen + additived_margen) / max_margen) * 100).round(2)

    render :json => {balance: margen}
  end

end
