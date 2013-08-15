class PurchaseProcessCreditorDisqualificationsController < CrudController
  def new
    object = build_resource
    object.licitation_process_id = params[:licitation_process_id]
    object.creditor_id = params[:creditor_id]
    object.disqualification_date = Date.current
  end

  def create
    create! do |success, failure|
      success.html { redirect_to creditor_proposals_path }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to creditor_proposals_path }
    end
  end

  private

  def creditor_proposals_path
    purchase_process_proposals_path(licitation_process_id: resource.licitation_process_id)
  end
end
