class BiddersController < CrudController
  has_scope :won_calculation, :type => :boolean
  has_scope :without_ratification, :type => :boolean

  before_filter :block_not_allow_bidders, :only => [ :new, :create, :update, :destroy ]
  before_filter :block_changes_when_have_ratifications, :only => [:create, :update, :destroy]

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
    if parent_id
      parent
    end
  end

  protected

  def main_controller_name
    'administrative_processes'
  end

  def parent
    @parent ||= parent_from_params_or_bidder
  end

  def parent_id
    return unless params[:licitation_process_id] || params[:bidder]

    params[:licitation_process_id] || params[:bidder][:licitation_process_id]
  end

  def parent_from_params_or_bidder
    if parent_id
      LicitationProcess.find(parent_id)
    else
      Bidder.find(params[:id]).licitation_process
    end
  end

  def create_resource(object)
    return unless object.envelope_opening?

    object.transaction do
      if super
        LicitationProcessStatusChanger.new(object.licitation_process).in_progress!
      end
    end
  end

  def update_resource(object, attributes)
    return unless object.envelope_opening?

    super
  end

  def block_not_allow_bidders
    raise Exceptions::Unauthorized unless parent.allow_bidders?
  end

  def block_changes_when_have_ratifications
    return unless parent.ratification?

    raise ActiveRecord::RecordNotFound
  end
end
