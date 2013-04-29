class PurchaseProcessCreditorProposalPathGenerator
  def initialize(purchase_process, controller)
    @controller       = controller
    @purchase_process = purchase_process
    @kind             = purchase_process.judgment_form.kind
  end

  def proposals_path
    controller.send "creditors_purchase_process_#{kind}_creditor_proposals_path", params
  end

  def new_proposal_path(creditor)
    with_creditor creditor do
      controller.send "new_purchase_process_#{kind}_creditor_proposal_path", params
    end
  end

  def edit_proposal_path(creditor)
    with_creditor creditor do
      controller.send "batch_edit_purchase_process_#{kind}_creditor_proposals_path", params
    end
  end

  def disqualify_proposal_path(creditor)
    with_creditor creditor do
      if disqualification.new_record?
        controller.new_purchase_process_creditor_disqualification_path params
      else
        controller.edit_purchase_process_creditor_disqualification_path disqualification
      end
    end
  end

  def form_proposal_path(action)
    if edit_actions.include? action
      batch_update_params
    else
      create_params
    end
  end

  def create_params
    { url: controller.send("purchase_process_#{kind}_creditor_proposals_path"), method: :post }
  end

  def batch_update_params
    { url: controller.send("batch_update_purchase_process_#{kind}_creditor_proposals_path"), method: :put }
  end

  private

  attr_accessor :purchase_process, :creditor, :controller, :kind

  def with_creditor(creditor)
    self.creditor = creditor
    result = yield
    self.creditor = nil
    result
  end

  def params
    { licitation_process_id: purchase_process }.tap do |obj|
      obj.merge!(creditor_id: creditor) if creditor
    end
  end

  def disqualification
    PurchaseProcessCreditorDisqualification.find_or_initialize(purchase_process, creditor)
  end

  def edit_actions
    ["batch_edit", "batch_update"]
  end
end
