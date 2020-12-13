class Auction::AuctionsController < Auction::BaseController
  skip_before_filter :authenticate_user!, :except => [:create, :destroy]
  skip_before_filter :authorize_resource!, :except => [:create, :destroy]
  layout "electronic_auction"

  before_filter :get_appeals, only:[:index]

  has_scope :term

  def show
    render layout: "document"
  end



  def update
    update! do |success, failure|
      success.html { redirect_to collection_path }
      failure.html { render :edit }

      success.js { render content_type: "text/json" }
      failure.js { render :form_errors, content_type: "text/json", status: :unprocessable_entity }
    end
  end

  def external_index
  end

  def dashboard
  end

  private

  def create_resource(object)
    object.user = current_user

    super
  end

  def get_appeals
    @appeals = AuctionAppeal.where{ viewed.eq(nil) | viewed.eq(false) }
  end
end
