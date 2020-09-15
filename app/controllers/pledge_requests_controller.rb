class PledgeRequestsController < CrudController
  has_scope :purchase_process_id

  def create
    create! do |success, failure|
      success.html { redirect_to edit_pledge_request_path(resource) }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_pledge_request_path(resource) }
    end
  end
end
