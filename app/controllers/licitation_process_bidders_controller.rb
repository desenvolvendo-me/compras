class LicitationProcessBiddersController < CrudController
  belongs_to :licitation_process

  def index
    @licitation_process = LicitationProcess.find(params[:licitation_process_id])

    super
  end

  def new
    licitation_process = LicitationProcess.find(params[:licitation_process_id])
    unless licitation_process.envelope_opening?
      return render :file => "public/401", :layout => nil, :status => 401
    end

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
