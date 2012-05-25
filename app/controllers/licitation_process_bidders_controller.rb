class LicitationProcessBiddersController < CrudController
  belongs_to :licitation_process

  before_filter :block_not_allow_bidders, :only => [ :new, :create, :update, :destroy ]

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

  def block_not_allow_bidders
    return if parent.allow_bidders?

    render :file => "public/401", :layout => nil, :status => 401
  end
end
