class AdditiveSolicitationsController < CrudController

  def margin
    quantity = params["quantity"]
    value = params["value"]
    material = Material.find(params["material_id"])
    licitation_process = LicitationProcess.find(params["licitation_process_id"])

    render :json => {balance: 100}
  end

end
