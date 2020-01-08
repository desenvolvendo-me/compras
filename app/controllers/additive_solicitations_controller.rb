class AdditiveSolicitationsController < CrudController

  def margin
    quantity = params["quantity"].to_i
    value = params["value"].to_f
    material_id = params["material_id"]
    licitation_process_id = params["licitation_process_id"]

    response = AdditiveSolicitation.calc_items_margin(licitation_process_id, material_id, quantity, value)

    render :json => {balance: response["margen"]}
  end

end
