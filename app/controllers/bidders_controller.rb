class BiddersController < CrudController
  has_scope :won_calculation, :type => :boolean

  before_filter :block_changes_when_have_ratifications, :only => [:create, :update, :destroy]

  def index
    BidderCreditorCreator.create!(licitation_process)

    super
  end

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
    object.transaction do
      if super
        PurchaseProcessStatusChanger.new(object.licitation_process).in_progress!
      end
    end
  end

  def update_resource(object, attrubutes)
    object.transaction do
      if super
        PurchaseProcessStatusChanger.new(object.licitation_process).in_progress!
      end
    end
  end

  def block_changes_when_have_ratifications
    return unless parent.ratification?

    raise ActiveRecord::RecordNotFound
  end

  private

  def licitation_process
    LicitationProcess.find params[:licitation_process_id]
  end
end
