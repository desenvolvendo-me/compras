class Auction::AuctionsController < Auction::BaseController
  def create
    create! do |success, failure|
      success.html { redirect_to collection_path }
      failure.html { render :new }

      success.js { render content_type: 'text/json' }
      failure.js { render :form_errors, content_type: 'text/json', status: :unprocessable_entity }
    end
  end
  def update
    update! do |success, failure|
      success.html { redirect_to collection_path }
      failure.html { render :edit }

      success.js { render content_type: 'text/json' }
      failure.js { render :form_errors, content_type: 'text/json', status: :unprocessable_entity }
    end
  end
end
