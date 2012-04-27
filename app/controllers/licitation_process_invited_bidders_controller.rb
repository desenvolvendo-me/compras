class LicitationProcessInvitedBiddersController < CrudController
  belongs_to :licitation_process

  def new
    object = build_resource
    object.build_licitation_process_invited_bidder_documents

    super
  end
end
