class Auction::ProposalsController < Auction::BaseController

  defaults resource_class: LicitationProcess

  def index
    redirect_to auction_auctions_path
  end


  def edit
    object = resource
    unless object.creditor_proposal_term
      object.build_creditor_proposal_term(auction_id: params[:auction_id], creditor_id: @current_user.authenticable_id)
    end

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to edit_resource_path }
      failure.html { render :new }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_resource_path }
      failure.html { render :new }
    end
  end

  def auctioneer_view
    @auction = Auction.includes(licitation_process: [creditor_proposals: [:creditor]]).find(params[:auction_id])
  end

  def show
    render layout: "document"
  end

  protected

  def create_resource(object)
    object.creditor = current_user.authenticable

    super
  end
end
