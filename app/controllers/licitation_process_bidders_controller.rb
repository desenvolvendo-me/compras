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

  protected

  def create_resource(object)
    return unless object.envelope_opening?

    super
  end

  def update_resource(object, attributes)
    return unless object.envelope_opening?

    super
  end
end
