# encoding: utf-8
class PurchaseProcessCreditorDisqualificationsController < CrudController
  before_filter :load_licitation_process, only: [:new, :create]
  before_filter :load_creditor, only: [:new, :create]

  def new
    object = build_resource
    object.licitation_process = @licitation_process
    object.creditor = @creditor
    object.disqualification_date = Date.current
  end

  def create
    create! do |success, failure|
      success.html { redirect_to creditors_purchase_process_creditor_proposals_path(licitation_process_id: resource.licitation_process) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to creditors_purchase_process_creditor_proposals_path(licitation_process_id: resource.licitation_process) }
    end
  end

  private

  def load_licitation_process
    @licitation_process = LicitationProcess.find(params[:licitation_process_id])
  end

  def load_creditor
    @creditor = Creditor.find(params[:creditor_id])
  end
end
