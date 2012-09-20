class BiddersController < CrudController
  before_filter :block_not_allow_bidders, :only => [ :new, :create, :update, :destroy ]

  def new
    object = build_resource
    object.licitation_process = LicitationProcess.find(params[:licitation_process_id])
    object.build_documents

    BidderProposalBuilder.new(object).build!

    super
  end

  def edit
    BidderProposalBuilder.new(resource).build!

    super
  end

  def create
    create! { bidders_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def update
    update! { bidders_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def destroy
    destroy! { bidders_path(:licitation_process_id => resource.licitation_process_id) }
  end

  def begin_of_association_chain
    if params[:licitation_process_id]
      @parent = LicitationProcess.find(params[:licitation_process_id])
    end
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
    if params[:licitation_process_id]
      parent = LicitationProcess.find(params[:licitation_process_id])
    elsif params[:bidder]
      parent = LicitationProcess.find(params[:bidder][:licitation_process_id])
    else
      parent = Bidder.find(params[:id]).licitation_process
    end

    raise Exceptions::Unauthorized unless parent.allow_bidders?
  end
end