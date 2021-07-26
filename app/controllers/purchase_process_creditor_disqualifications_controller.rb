class PurchaseProcessCreditorDisqualificationsController < CrudController
  def new
    object = build_resource
    object.licitation_process_id = params[:licitation_process_id]
    object.creditor_id = params[:creditor_id]
    object.disqualification_date = Date.current
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_licitation_process_path(resource.licitation_process_id) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to  edit_licitation_process_path(resource.licitation_process_id) }
    end
  end
end
