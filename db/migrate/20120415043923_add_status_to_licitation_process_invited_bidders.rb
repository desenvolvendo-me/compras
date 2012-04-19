class AddStatusToLicitationProcessInvitedBidders < ActiveRecord::Migration
  def change
    add_column :licitation_process_invited_bidders, :status, :string
  end
end
