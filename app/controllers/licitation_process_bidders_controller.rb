class LicitationProcessBiddersController < CrudController
  belongs_to :licitation_process

  def new
    object = build_resource
    object.build_documents
    LicitationProcessBidderProposalBuilder.new(object).build!

    super
  end

  def edit
    LicitationProcessBidderProposalBuilder.new(resource).build!

    super
  end
end
