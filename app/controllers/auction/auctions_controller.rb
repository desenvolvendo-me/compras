class Auction::AuctionsController < Auction::BaseController
  skip_before_filter :authenticate_user!, :only => :external_index
  skip_before_filter :authorize_resource!, :only => :external_index
  layout "electronic_auction"

  before_filter :get_appeals, only:[:index]

  has_scope :term

  def new
    object = build_resource
    object.year = Time.now.year

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to collection_path }
      failure.html { render :new }

      success.js { render content_type: "text/json" }
      failure.js { render :form_errors, content_type: "text/json", status: :unprocessable_entity }
    end
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

  def show
    render layout: "document"
  end

  private

  def get_appeals
    @appeals = AuctionAppeal.where{ viewed.eq(nil) | viewed.eq(false) }
  end
end
