class AdditiveSolicitationsController < CrudController

  def margin
    material = Material.find(params["material_id"])
    licitation_process = LicitationProcess.find(params["licitation_process_id"])

    render :json => {balance: 100, value: 50}
  end

end
