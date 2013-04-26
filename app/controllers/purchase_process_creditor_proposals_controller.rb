# encoding: utf-8
class PurchaseProcessCreditorProposalsController < CrudController
  custom_actions collection: [:creditors, :batch_edit, :batch_update]

  before_filter :load_licitation_process
  before_filter :load_path_generator
  before_filter :load_creditor, only: [:new, :batch_edit]

  def new
    object = build_resource
    object.creditor = @creditor
    object.licitation_process = @licitation_process

    TradingCreator.create!(@licitation_process)
  end

  def create
    create! do |success, failure|
      success.html { redirect_to @proposal_path_generator.proposals_path }
    end
  end

  def batch_edit
    object = build_resource
    object.creditor = @creditor
    object.licitation_process = @licitation_process
  end

  def batch_update
    object = build_resource

    update! do |success, failure|
      success.html { redirect_to @proposal_path_generator.proposals_path }
      failure.html { render :batch_edit }
    end
  end

  def creditors
    object = build_resource
    object.licitation_process = @licitation_process
    @creditors = @licitation_process.creditors.includes(:purchase_process_creditor_proposals)
  end

  private

  def load_licitation_process
    @licitation_process = LicitationProcess.find(params[:licitation_process_id])
  end

  def load_path_generator
    @proposal_path_generator = PurchaseProcessCreditorProposalPathGenerator.new(@licitation_process, self)
  end

  def load_creditor
    @creditor = Creditor.find(params[:creditor_id])
  end

  def create_resource(object)
    @licitation_process.localized.assign_attributes(params[:licitation_process])
    super unless @licitation_process.save
  end

  def update_resource(object, resource_params)
    @licitation_process.localized.assign_attributes(params[:licitation_process])
    super unless @licitation_process.save
  end
end
