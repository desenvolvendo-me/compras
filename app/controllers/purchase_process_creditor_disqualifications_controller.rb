# encoding: utf-8
class PurchaseProcessCreditorDisqualificationsController < CrudController
  before_filter :load_licitation_process, only: [:new, :create]
  before_filter :load_creditor, only: [:new, :create]
  before_filter :load_proposal_path_generator

  def new
    object = build_resource
    object.licitation_process = @licitation_process
    object.creditor = @creditor
    object.disqualification_date = Date.current
  end

  def create
    create! do |success, failure|
      success.html { redirect_to @proposal_path_generator.proposals_path }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to @proposal_path_generator.proposals_path }
    end
  end

  private

  def load_licitation_process
    @licitation_process = LicitationProcess.find(params[:licitation_process_id])
  end

  def load_creditor
    @creditor = Creditor.find(params[:creditor_id])
  end

  def load_proposal_path_generator
    purchase_process = @licitation_process || resource.licitation_process
    @proposal_path_generator = PurchaseProcessCreditorProposalPathGenerator.new(purchase_process, self)
  end
end
