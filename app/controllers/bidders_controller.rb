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

  def main_controller_name
    'administrative_processes'
  end

  def create_resource(object)
    return unless object.envelope_opening?

    object.transaction do
      if super
        update_licitation_process_status(object.licitation_process)
      end
    end
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

  def update_licitation_process_status(licitation_process)
    return if licitation_process.in_progress?

    licitation_process.update_status(LicitationProcessStatus::IN_PROGRESS)
  end
end
