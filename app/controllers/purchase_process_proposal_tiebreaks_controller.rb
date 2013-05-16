class PurchaseProcessProposalTiebreaksController < CrudController
  defaults resource_class: LicitationProcess, instance_name: :purchase_process

  before_filter :load_path_generator, only: [:edit, :update]

  def update
    update! { @proposal_path_generator.proposals_path }
  end

  private

  def load_path_generator
    @proposal_path_generator = PurchaseProcessCreditorProposalPathGenerator.new(resource, self)
  end
end
